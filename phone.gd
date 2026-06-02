extends TextureButton

signal phone_call_ended

const ACT_SCORE_RATINGS := {
	1: "wrong",
	2: "mediocre",
	3: "correct",
}
const PHONE_DIALOGUES := [
	[],
	# Act 1
	[
		[],
		# Score 1
		[
			"[color=#cfa66a]James:[/color] Wolf was acting strange last night, sir — kept circling where you left that food out. Something's got it confused.",
			"[color=#9fb4d8]Marcus:[/color] Scare them away if they come close. I will not have wolves disrupting the site.",
		],
		# Score 2
		[
			"[color=#cfa66a]James:[/color] Heard you scared off the wolf last night. Some of the crew are on edge about it.",
			"[color=#9fb4d8]Marcus:[/color] Noted. Keep working. It'll sort itself out.",
		],
		# Score 3
		[
			"[color=#cfa66a]James:[/color] Status report — wolf was back last night, circling the perimeter again. Didn't come close though.",
			"[color=#9fb4d8]Marcus:[/color] Leave it. It's doing what wolves do. Make sure the crew knows not to engage it.",
		],
	],
	# Act 2
	[
		[],
		# Score 1
		[
			"[color=#cfa66a]Dale:[/color] We caught that wolf in a snare this morning, sir. Hell of a mess. What do you want us to do with it?",
			"[color=#9fb4d8]Marcus:[/color] ...Call wildlife services. And tell the crew that was not the plan.",
		],
		# Score 2
		[
			"[color=#cfa66a]Dale:[/color] Wolf's still hanging around the perimeter. Hasn't caused trouble, but it's not going away either.",
			"[color=#9fb4d8]Marcus:[/color] Keep an eye on it. Don't engage. I'll figure it out.",
		],
		# Score 3
		[
			"[color=#cfa66a]Dale:[/color] Wolf's been around again. Crew's a bit spooked. You feeding it now?",
			"[color=#9fb4d8]Marcus:[/color] Once. It was hungry, not aggressive. Just keep your distance and it'll keep its.",
		],
	],
	# Act 3
	[
		[],
		# Score 1
		[
			"[color=#cfa66a]Dr. Osei:[/color] Marcus. Phase 3. I know you've been out there. I know what that land looks like. I just wanted you to hear a different voice before tomorrow.",
			"[color=#9fb4d8]Marcus:[/color] ...I appreciate the call. I'll think about it.",
		],
		# Score 2
		[
			"[color=#cfa66a]Dr. Osei:[/color] Marcus. Phase 3 goes to committee tomorrow. I'm calling everyone I know in that district. Is there anything you want to say before it's final?",
			"[color=#9fb4d8]Marcus:[/color] I'll see what I can do from the inside. No promises.",
		],
		# Score 3
		[
			"[color=#cfa66a]Dr. Osei:[/color] Marcus. I heard you helped a wolf last night. I also heard about Phase 3. The door here is still open, if you want to talk before the meeting.",
			"[color=#9fb4d8]Marcus:[/color] I'll be at the meeting tomorrow. I'm not sure yet what I'm going to say. But I'll be there.",
		],
	],
]
const ENDING_PHONE_DIALOGUES := {
	"corporate": [
		"[color=#cfa66a]Corporate Voicemail:[/color] Marcus, just wanted to say — good showing today. Phase 3 is a go. Performance review in the new year. We're glad to have you in the room.",
		"[color=#9fb4d8]Marcus:[/color] ..."
	],
	"activist": [
		"[color=#cfa66a]Dale:[/color] Heard you pushed back in there today. Didn't think you had it in you, Marcus. ...Good.",
		"[color=#9fb4d8]Marcus:[/color] Keep the crew away from the northern corridor, Dale. We're rerouting."
	],
	"scientist": [
		"[color=#cfa66a]Dr. Osei:[/color] I didn't expect to hear from you today. Are you sure?",
		"[color=#9fb4d8]Marcus:[/color] I'm sure. I'll see you Monday."
	]
}

@onready var ring_lines: TextureRect = $RingLines
@onready var ring_sound: AudioStreamPlayer = $RingSound
@onready var pickup_sound: AudioStreamPlayer = $PickupSound
@onready var slam_sound: AudioStreamPlayer = $SlamSound
@onready var voicebox = $ACVoiceBox

@onready var dialogue_box: Control = $"../../PhoneDialogue"
@onready var dialogue_label: RichTextLabel = $"../../PhoneDialogue/DialogueLabel"
@onready var main =  $"../../.."
@onready var notebook = $"../../../OpenNotebook"
@onready var wolf_button = $"../../Outside/Wolf/WolfButton"
@onready var animalia_button = $"../Animalia"
@onready var notepad_button = $"../Notepad"

var is_ringing := false
var in_call := false
var base_pos: Vector2
var jitter_timer := 0.0
var dialogue_index := 0
var dialogue_lines: Array = []

var is_typing := false
var clean_text := ""
var visible_text_length := 0


func _ready() -> void:
	base_pos = position

	pressed.connect(_on_pressed)
	dialogue_box.gui_input.connect(_on_dialogue_box_gui_input)

	voicebox.characters_sounded.connect(_on_voicebox_characters_sounded)
	voicebox.finished_phrase.connect(_on_voicebox_finished_phrase)

	dialogue_label.bbcode_enabled = true
	dialogue_label.visible_characters = 0

	ring_lines.visible = false
	dialogue_box.visible = false
	voicebox.volume_db = -10


func _process(delta: float) -> void:
	if is_ringing:
		jitter_timer += delta

		if jitter_timer >= 0.05:
			jitter_timer = 0.0
			position = base_pos + Vector2(
				randi_range(-2, 2),
				randi_range(-1, 1)
			)


func start_ringing() -> void:
	if is_ringing or in_call:
		return

	is_ringing = true
	jitter_timer = 0.0
	position = base_pos
	ring_lines.visible = true
	ring_sound.play()


func do_phone_call(call_act: int, item_score: int) -> bool:
	dialogue_lines = _get_dialogue_lines(call_act, item_score)
	wolf_button.disabled = true
	wolf_button.mouse_default_cursor_shape = Control.CURSOR_ARROW

	if dialogue_lines.is_empty():
		return false

	start_ringing()
	return true


func _get_dialogue_lines(call_act: int, item_score: int) -> Array:
	if call_act < 0 or call_act >= PHONE_DIALOGUES.size():
		push_warning("Missing phone dialogue for act: %s" % call_act)
		return []

	var act_dialogues: Array = PHONE_DIALOGUES[call_act] as Array

	if item_score < 0 or item_score >= act_dialogues.size():
		push_warning("Missing phone dialogue for act %s score %s" % [call_act, item_score])
		return []

	var selected_dialogue: Array = act_dialogues[item_score] as Array

	if selected_dialogue.is_empty():
		push_warning("Missing phone dialogue for act %s score %s" % [call_act, item_score])
		return []

	return selected_dialogue.duplicate()


func stop_ringing() -> void:
	is_ringing = false
	position = base_pos
	ring_lines.visible = false
	ring_sound.stop()


func _on_pressed() -> void:
	if is_ringing:
		pick_up_phone()


func pick_up_phone() -> void:
	stop_ringing()
	
	animalia_button.disabled=true
	notepad_button.disabled=true
	

	in_call = true
	dialogue_index = 0

	pickup_sound.play()
	dialogue_box.visible = true

	show_dialogue_line()


func show_dialogue_line() -> void:
	var formatted_text: String = dialogue_lines[dialogue_index]

	clean_text = _strip_bbcode(formatted_text)
	visible_text_length = 0
	is_typing = true

	dialogue_label.text = formatted_text
	dialogue_label.visible_characters = 0

	voicebox.base_pitch = randf_range(3.5, 4.2)
	voicebox.play_string(clean_text)


func _on_dialogue_box_gui_input(event: InputEvent) -> void:
	if not in_call:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_typing:
			finish_typing_line()
		else:
			advance_dialogue()


func _on_voicebox_characters_sounded(characters: String) -> void:
	if not is_typing:
		return

	visible_text_length += characters.length()
	dialogue_label.visible_characters = visible_text_length


func _on_voicebox_finished_phrase() -> void:
	if not is_typing:
		return

	is_typing = false
	visible_text_length = clean_text.length()
	dialogue_label.visible_characters = visible_text_length


func finish_typing_line() -> void:
	is_typing = false
	visible_text_length = clean_text.length()
	dialogue_label.visible_characters = visible_text_length

	if voicebox.has_method("stop_voice"):
		voicebox.stop_voice()
	else:
		voicebox.stop()


func advance_dialogue() -> void:
	dialogue_index += 1

	if dialogue_index >= dialogue_lines.size():
		end_call()
	else:
		show_dialogue_line()


func end_call() -> void:
	in_call = false
	is_typing = false

	dialogue_box.visible = false
	
	animalia_button.disabled=false
	notepad_button.disabled=false

	if voicebox.has_method("stop_voice"):
		voicebox.stop_voice()
	else:
		voicebox.stop()

	slam_sound.play()
	notebook.unlock_post_act_entry(main.act, ACT_SCORE_RATINGS[main.current_act_score])
	wolf_button.disabled = false
	wolf_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	phone_call_ended.emit()


func _strip_bbcode(text: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(text, "", true)

func do_ending_phone_call(ending_id: String) -> bool:
	if not ENDING_PHONE_DIALOGUES.has(ending_id):
		push_warning("Missing ending phone dialogue: %s" % ending_id)
		return false

	dialogue_lines = ENDING_PHONE_DIALOGUES[ending_id].duplicate()

	start_ringing()
	return true

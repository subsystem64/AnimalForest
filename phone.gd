extends TextureButton

signal phone_call_ended

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

@onready var ring_lines: TextureRect = $RingLines
@onready var ring_sound: AudioStreamPlayer = $RingSound
@onready var pickup_sound: AudioStreamPlayer = $PickupSound
@onready var slam_sound: AudioStreamPlayer = $SlamSound
@onready var voicebox = $ACVoiceBox

@onready var dialogue_box: Control = $"../../PhoneDialogue"
@onready var dialogue_label: RichTextLabel = $"../../PhoneDialogue/DialogueLabel"

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

	if voicebox.has_method("stop_voice"):
		voicebox.stop_voice()
	else:
		voicebox.stop()

	slam_sound.play()
	phone_call_ended.emit()


func _strip_bbcode(text: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(text, "", true)

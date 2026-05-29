extends TextureButton

@onready var ring_lines: TextureRect = $RingLines
@onready var ring_sound: AudioStreamPlayer = $RingSound
@onready var pickup_sound: AudioStreamPlayer = $PickupSound
@onready var slam_sound: AudioStreamPlayer = $SlamSound

@onready var dialogue_box: Control = $"../../PhoneDialogue"
@onready var dialogue_label: RichTextLabel = $"../../PhoneDialogue/DialogueLabel"

var is_ringing := false
var in_call := false
var base_pos: Vector2
var jitter_timer := 0.0
var dialogue_index := 0

var dialogue_lines := [
	"James:  Status report — wolf was back last night, circling the perimeter again. Didn't come close though.",
	"Marcus:  Leave it. It's doing what wolves do. Make sure the crew knows not to engage it."
]

func _ready() -> void:
	base_pos = position
	pressed.connect(_on_pressed)
	dialogue_box.gui_input.connect(_on_dialogue_box_gui_input)

	ring_lines.visible = false
	dialogue_box.visible = false

	# TESTING ONLY. Remove later when story events trigger the call.
	start_ringing()

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
	ring_lines.visible = true
	ring_sound.play()

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
	pickup_sound.play()

	dialogue_index = 0
	dialogue_box.visible = true
	show_dialogue_line()

func show_dialogue_line() -> void:
	dialogue_label.text = dialogue_lines[dialogue_index]

func _on_dialogue_box_gui_input(event: InputEvent) -> void:
	if not in_call:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		advance_dialogue()

func advance_dialogue() -> void:
	dialogue_index += 1

	if dialogue_index >= dialogue_lines.size():
		end_call()
	else:
		show_dialogue_line()

func end_call() -> void:
	in_call = false
	dialogue_box.visible = false
	slam_sound.play()

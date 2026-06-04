extends Control

const MORNING_BACKGROUND := preload("res://assets/Environment/MorningBackground.png")

@onready var phone = $"../Control/Desk/Phone"
@onready var epilogue_screen = $"../EpilogueScreen"
@onready var animalia = $"../Control/Desk/Animalia"
@onready var notepad = $"../Control/Desk/Notepad"
@onready var outside_background = $"../Control/Outside/OutsideBackground"
@onready var wolf_button = $"../Control/Outside/Wolf/WolfButton"
@onready var laptop = $Laptop
@onready var email_popup = $EmailPopup
@onready var draft_1 = $EmailPopup/Draft1
@onready var draft_1_button = $EmailPopup/Draft1/Draft1Button
@onready var draft_1_open = $EmailPopup/Draft1/Draft1Open
@onready var draft_1_close_button = $EmailPopup/Draft1/Draft1Open/Draft1CloseButton
@onready var draft_2 = $EmailPopup/Draft2
@onready var draft_2_button = $EmailPopup/Draft2/Draft2Button
@onready var draft_2_open = $EmailPopup/Draft2/Draft2Open
@onready var draft_2_close_button = $EmailPopup/Draft2/Draft2Open/Draft2CloseButton
@onready var draft_3 = $EmailPopup/Draft3
@onready var draft_3_button = $EmailPopup/Draft3/Draft3Button
@onready var draft_3_open = $EmailPopup/Draft3/Draft3Open
@onready var draft_3_close_button = $EmailPopup/Draft3/Draft3Open/Draft3CloseButton


func _ready() -> void:
	laptop.pressed.connect(_on_laptop_pressed)
	draft_1_button.pressed.connect(_on_draft_button_pressed.bind(draft_1_open))
	draft_1_close_button.pressed.connect(_on_draft_close_button_pressed.bind(draft_1_open))
	draft_2_button.pressed.connect(_on_draft_button_pressed.bind(draft_2_open))
	draft_2_close_button.pressed.connect(_on_draft_close_button_pressed.bind(draft_2_open))
	draft_3_button.pressed.connect(_on_draft_button_pressed.bind(draft_3_open))
	draft_3_close_button.pressed.connect(_on_draft_close_button_pressed.bind(draft_3_open))


func _on_laptop_pressed() -> void:
	email_popup.visible = true


func _on_draft_button_pressed(draft_open: Control) -> void:
	draft_open.visible = true


func _on_draft_close_button_pressed(draft_open: Control) -> void:
	draft_open.visible = false


func play_ending_sequence(score: int) -> void:
	var ending_id := get_ending_id(score)

	draft_1.visible = true
	draft_2.visible = score >= 6
	draft_3.visible = score >= 9

	animalia.disabled = true
	animalia.visible = false
	notepad.disabled = true
	notepad.visible = false

	outside_background.texture = MORNING_BACKGROUND
	wolf_button.disabled = true
	wolf_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	



	if phone.has_method("do_ending_phone_call"):
		var ending_call_started := bool(phone.call("do_ending_phone_call", ending_id))

		if ending_call_started and phone.has_signal("phone_call_ended"):
			await phone.phone_call_ended
		elif ending_call_started:
			push_warning("Phone is missing phone_call_ended")
	else:
		push_warning("Phone is missing do_ending_phone_call")

	epilogue_screen.show_epilogue(ending_id)
	await epilogue_screen.epilogue_finished


func get_ending_id(score: int) -> String:
	if score >= 9:
		return "scientist"
	elif score >= 6:
		return "activist"
	else:
		return "corporate"

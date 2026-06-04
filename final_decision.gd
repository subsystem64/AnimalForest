extends Control

const MORNING_BACKGROUND := preload("res://assets/Environment/MorningBackground.png")
const INBOX_1 := preload("res://assets/Computer/inbox_screen1.png")
const INBOX_2 := preload("res://assets/Computer/inbox_screen2.png")
const INBOX_3 := preload("res://assets/Computer/inbox_screen3.png")

@onready var phone = $"../Control/Desk/Phone"
@onready var epilogue_screen = $"../EpilogueScreen"
@onready var animalia = $"../Control/Desk/Animalia"
@onready var notepad = $"../Control/Desk/Notepad"
@onready var outside_background = $"../Control/Outside/OutsideBackground"
@onready var wolf_button = $"../Control/Outside/Wolf/WolfButton"
@onready var laptop = $Laptop
@onready var email_popup = $EmailPopup
@onready var draft_1_button = $EmailPopup/Draft1Button
@onready var draft_1_open = $EmailPopup/Draft1Open
@onready var draft_1_close_button = $EmailPopup/Draft1Open/Draft1CloseButton
@onready var send_1_button = $EmailPopup/Draft1Open/Send1Button
@onready var draft_2_button = $EmailPopup/Draft2Button
@onready var draft_2_open = $EmailPopup/Draft2Open
@onready var draft_2_close_button = $EmailPopup/Draft2Open/Draft2CloseButton
@onready var send_2_button = $EmailPopup/Draft2Open/Send2Button
@onready var draft_3_button = $EmailPopup/Draft3Button
@onready var draft_3_open = $EmailPopup/Draft3Open
@onready var draft_3_close_button = $EmailPopup/Draft3Open/Draft3CloseButton
@onready var send_3_button = $EmailPopup/Draft3Open/Send3Button
@onready var inbox = $EmailPopup/Inbox
@onready var exit_button = $EmailPopup/ExitButton
@onready var main = $".."
@onready var blink_holder = $CanvasLayer/BlinkHolder



func _ready() -> void:
	laptop.pressed.connect(_on_laptop_pressed)
	draft_1_button.pressed.connect(_on_draft_button_pressed.bind(draft_1_open))
	draft_1_close_button.pressed.connect(_on_draft_close_button_pressed.bind(draft_1_open))
	draft_2_button.pressed.connect(_on_draft_button_pressed.bind(draft_2_open))
	draft_2_close_button.pressed.connect(_on_draft_close_button_pressed.bind(draft_2_open))
	draft_3_button.pressed.connect(_on_draft_button_pressed.bind(draft_3_open))
	draft_3_close_button.pressed.connect(_on_draft_close_button_pressed.bind(draft_3_open))
	send_1_button.pressed.connect(_on_send_button_pressed.bind("corporate"))
	send_2_button.pressed.connect(_on_send_button_pressed.bind("activist"))
	send_3_button.pressed.connect(_on_send_button_pressed.bind("scientist"))
	exit_button.pressed.connect(email_popup.hide)


func _on_laptop_pressed() -> void:
	email_popup.visible = true


func _on_draft_button_pressed(draft_open: Control) -> void:
	draft_open.visible = true
	draft_1_button.disabled = true
	draft_2_button.disabled = true
	draft_3_button.disabled = true
	inbox.visible = false


func _on_draft_close_button_pressed(draft_open: Control) -> void:
	draft_open.visible = false
	if main.score >= 9:
		draft_3_button.disabled = false
	if main.score >= 6:
		draft_2_button.disabled = false
	draft_1_button.disabled = false
	inbox.visible = true


func _on_send_button_pressed(ending_id: String) -> void:
	disable_final_decision()
	
	await blink_holder.play_close()

	
	await blink_holder.play_open()
	
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


func disable_final_decision() -> void:
	hide()
	send_1_button.disabled = true
	send_2_button.disabled = true
	send_3_button.disabled = true


func play_ending_sequence(score: int) -> void:
	draft_1_button.visible = true
	draft_1_button.disabled = false
	draft_2_button.visible = score >= 6
	draft_2_button.disabled = score < 6
	draft_3_button.visible = score >= 9
	draft_3_button.disabled = score < 9
	
	if score >= 9:
		inbox.texture = INBOX_3
	elif score >= 6:
		inbox.texture = INBOX_2
	else:
		inbox.texture = INBOX_1

	show()

	animalia.disabled = true
	animalia.visible = false
	notepad.disabled = true
	notepad.visible = false
	laptop.disabled = false
	laptop.visible = true

	outside_background.texture = MORNING_BACKGROUND
	wolf_button.disabled = true
	wolf_button.mouse_default_cursor_shape = Control.CURSOR_ARROW

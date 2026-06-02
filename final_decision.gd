extends Control

const MORNING_BACKGROUND := preload("res://assets/Environment/MorningBackground.png")

@onready var phone = $"../Control/Desk/Phone"
@onready var epilogue_screen = $"../EpilogueScreen"
@onready var animalia = $"../Control/Desk/Animalia"
@onready var notepad = $"../Control/Desk/Notepad"
@onready var outside_background = $"../Control/Outside/OutsideBackground"
@onready var wolf_button = $"../Control/Outside/Wolf/WolfButton"



func play_ending_sequence(score: int) -> void:
	var ending_id := get_ending_id(score)

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

extends Control

signal act_changed(act: int)
signal score_changed(score: int)

const ITEM_ACT_SCORES := {
	"Water":	   [1, 2, 1],
	"Dart": 	   [1, 2, 2],
	"Food":        [1, 3, 1],
	"Mug":         [3, 1, 1],
	"Bedroll":     [1, 2, 2],
	"Rifle":       [2, 2, 1],
	"FirstAidKit": [1, 1, 3],
	"WoodenPost":  [2, 1, 2],
	"Phone": 	   [2, 2, 2],
	"Rope": 		   [1, 1, 1],
}

const MORNING_BACKGROUND := preload("res://assets/Environment/MorningBackground.png")

@export_range(1, 3) var act := 1:
	set(value):
		var new_act := clampi(value, 1, 4)
		if act == new_act:
			return

		act = new_act
		act_changed.emit(act)

@export var score := 0:
	set(value):
		if score == value:
			return

		score = value
		score_changed.emit(score)

@export var current_act_score := 0

@onready var outside_background: TextureRect = $Control/Outside/OutsideBackground
@onready var phone = $Control/Desk/Phone
@onready var blink_holder = $ActionCutscene/CanvasLayer/BlinkHolder
@onready var final_decision = $FinalDecision
@onready var shelf = $Control/Shelf
@onready var ambient_sound: AudioStreamPlayer = $AmbientSound


func _ready() -> void:
	$Act1Cutscene.start_act1_cutscene()
	# ambient_sound.play()


func _process(delta: float) -> void:
	pass


func advance_level() -> void:
	act = act + 1

	shelf.clear_selected_item()
	
	if act == 2:
		$Act2Cutscene.start_act2_cutscene()
		await $Act2Cutscene.act_2_cutscene_started
		blink_holder.play_open()
	elif act == 3:
		$Act3Cutscene.start_act3_cutscene()
		await $Act3Cutscene.act_3_cutscene_started
		blink_holder.play_open()


func do_act_transition(item_name: String) -> void:
	var item_score := score_item_for_current_act(item_name)
	current_act_score = item_score
	outside_background.texture = MORNING_BACKGROUND

	if phone.has_method("do_phone_call"):
		var phone_call_started := bool(phone.call("do_phone_call", act, item_score))
		if phone_call_started and phone.has_signal("phone_call_ended"):
			await phone.phone_call_ended
		elif phone_call_started:
			push_warning("Phone is missing phone_call_ended")
	else:
		push_warning("Phone is missing do_phone_call")

	await blink_holder.play_close()

	if act == 3:
		blink_holder.play_open()
		final_decision.play_ending_sequence(score)
	else:
		await advance_level()


func score_item_for_current_act(item_name: String) -> int:
	if not item_name in ITEM_ACT_SCORES:
		push_warning("Missing score values for item: %s" % item_name)
		return 0

	var act_scores: Array = ITEM_ACT_SCORES[item_name] as Array
	var score_index := act - 1

	if score_index < 0 or score_index >= act_scores.size():
		push_warning("Missing score value for item %s in act %s" % [item_name, act])
		return 0

	var item_score := int(act_scores[score_index])
	score += item_score
	return item_score

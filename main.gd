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
}

const MORNING_BACKGROUND := preload("res://assets/Environment/MorningBackground.png")

@export_range(0, 2) var act := 0:
	set(value):
		var new_act := clampi(value, 0, 2)
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

@onready var outside_background: TextureRect = $Control/Outside/OutsideBackground
@onready var phone: TextureButton = $Control/Desk/Phone


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Act1Cutscene.start_act1_cutscene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func advance_level() -> void:
	act = (act + 1) % 3

func do_act_transition(item_name: String) -> void:
	var item_score := score_item_for_current_act(item_name)
	outside_background.texture = MORNING_BACKGROUND

	if phone.has_method("do_phone_call"):
		phone.call("do_phone_call", act, item_score)
	else:
		push_warning("Phone is missing do_phone_call")

	advance_level()


func score_item_for_current_act(item_name: String) -> int:
	if not item_name in ITEM_ACT_SCORES:
		push_warning("Missing score values for item: %s" % item_name)
		return 0

	var act_scores: Array = ITEM_ACT_SCORES[item_name] as Array
	if act < 0 or act >= act_scores.size():
		push_warning("Missing score value for item %s in act %s" % [item_name, act])
		return 0

	var item_score := int(act_scores[act])
	score += item_score
	return item_score

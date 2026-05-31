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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Act1Cutscene.start_act1_cutscene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func advance_level() -> void:
	act = (act + 1) % 3


func score_item_for_current_act(item_name: String) -> void:
	if not item_name in ITEM_ACT_SCORES:
		push_warning("Missing score values for item: %s" % item_name)
		return

	var act_scores: Array = ITEM_ACT_SCORES[item_name] as Array
	if act < 0 or act >= act_scores.size():
		push_warning("Missing score value for item %s in act %s" % [item_name, act])
		return

	score += int(act_scores[act])

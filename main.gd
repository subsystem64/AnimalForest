extends Control

signal act_changed(act: int)

@export_range(0, 2) var act := 0:
	set(value):
		var new_act := clampi(value, 0, 2)
		if act == new_act:
			return

		act = new_act
		act_changed.emit(act)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Act1Cutscene.start_act1_cutscene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func advance_level() -> void:
	act = (act + 1) % 3

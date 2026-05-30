extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Act1Cutscene.start_act1_cutscene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

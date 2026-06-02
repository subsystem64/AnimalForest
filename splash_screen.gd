extends Control

@export var main_scene_path := "res://main.tscn"

var pressed := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func _input(event: InputEvent) -> void:
	if pressed:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		pressed = true
		get_tree().change_scene_to_file(main_scene_path)

	if event is InputEventMouseButton and event.pressed:
		pressed = true
		get_tree().change_scene_to_file(main_scene_path)

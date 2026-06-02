extends Control

@export var main_scene_path := "res://main.tscn"

@onready var press_any_key: Label = $PressAnyKey

var pressed := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

	press_any_key.text = "Press Any Key"
	press_any_key.modulate = Color(0.85, 0.70, 0.45, 0.9)
	press_any_key.scale = Vector2.ONE

	await get_tree().process_frame
	press_any_key.pivot_offset = press_any_key.size / 2.0


func _input(event: InputEvent) -> void:
	if pressed:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		await press_start()

	elif event is InputEventMouseButton and event.pressed:
		await press_start()


func press_start() -> void:
	pressed = true

	var tween := create_tween()

	tween.tween_property(
		press_any_key,
		"modulate",
		Color(1.0, 0.9, 0.45, 1.0),
		0.08
	)

	tween.parallel().tween_property(
		press_any_key,
		"scale",
		Vector2(1.08, 1.08),
		0.08
	)

	await tween.finished
	await get_tree().create_timer(0.15).timeout

	get_tree().change_scene_to_file(main_scene_path)

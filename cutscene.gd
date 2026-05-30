extends Control

const ITEM_CUTSCENES := {
	"Water": "WaterAction",
	"Food": "FoodAction",
}

@onready var blink_holder: Control = $CanvasLayer/BlinkHolder
@onready var wolf: Control = $"../Control/Outside/Wolf"

var can_close_after_release := false
var is_closing := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	blink_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	_hide_cutscenes()


func _process(_delta: float) -> void:
	if not visible or is_closing:
		return

	var is_mouse_pressed := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if not is_mouse_pressed:
		can_close_after_release = true
	elif can_close_after_release:
		_close_to_main_scene()


func show_for_item(item_name: String) -> void:
	_hide_cutscenes()
	visible = true
	can_close_after_release = false
	is_closing = false

	if not item_name in ITEM_CUTSCENES:
		push_warning("Missing action cutscene item: %s" % item_name)
		return

	var cutscene_name: String = ITEM_CUTSCENES[item_name] as String
	var cutscene: CanvasItem = get_node_or_null(cutscene_name) as CanvasItem
	if cutscene == null:
		push_warning("Missing action cutscene: %s" % cutscene_name)
		return

	cutscene.visible = true


func _close_to_main_scene() -> void:
	is_closing = true
	can_close_after_release = false

	await blink_holder.call("play_transition")

	if wolf.has_method("advance_level"):
		wolf.call("advance_level")
	else:
		push_warning("Wolf is missing advance_level")

	visible = false
	_hide_cutscenes()
	is_closing = false


func _hide_cutscenes() -> void:
	for child: Node in get_children():
		var cutscene: CanvasItem = child as CanvasItem
		if cutscene != null:
			cutscene.visible = false

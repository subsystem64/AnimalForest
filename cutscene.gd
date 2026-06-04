extends Control

const ITEM_CUTSCENES := {
	1: {
		"Water": "Act1WaterAction",
		"Dart": "Act1DartAction",
		"Food": "Act1FoodAction",
		"Mug": "Act1MugAction",
		"Bedroll": "Act1BedrollAction",
		"FirstAidKit": "Act1FirstAidKitAction",
		"WoodenPost": "Act1WoodenPostAction",
		"Rifle": "Act1RifleAction",
		"Rope": "Act1RopeAction",
		"Phone": "Act1PhoneAction",
	},
	2: {
		"Water": "Act2WaterAction2",
		"Dart": "Act2DartAction2",
		"Food": "Act2FoodAction2",
		"Mug": "Act2MugAction2",
		"Bedroll": "Act2BedrollAction2",
		"FirstAidKit": "Act2FirstAidKitAction2",
		"WoodenPost": "Act2WoodenPostAction2",
		"Rifle": "Act2RifleAction2",
		"Rope": "Act2RopeAction2",
		"Phone": "Act2PhoneAction2",
	},
	3: {
		"Water": "Act3WaterAction3",
		"Dart": "Act3DartAction3",
		"Food": "Act3FoodAction3",
		"Mug": "Act3MugAction3",
		"Bedroll": "Act3BedrollAction3",
		"FirstAidKit": "Act3FirstAidKitAction3",
		"WoodenPost": "Act3WoodenPostAction3",
		"Rifle": "Act3RifleAction3",
		"Rope": "Act3RopeAction3",
		"Phone": "Act3PhoneAction3",
	},
}
@onready var blink_holder = $CanvasLayer/BlinkHolder
@onready var main = $".."

var can_close_after_release := false
var is_closing := false
var current_item_name := ""


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
	current_item_name = item_name

	var act: int = main.act

	if not ITEM_CUTSCENES.has(act):
		push_warning("Missing cutscenes for act: %s" % act)
		return

	if not ITEM_CUTSCENES[act].has(item_name):
		push_warning("Missing action cutscene item: Act %s, %s" % [act, item_name])
		return

	var cutscene_name: String = ITEM_CUTSCENES[act][item_name]
	var cutscene: CanvasItem = get_node_or_null(cutscene_name) as CanvasItem

	if cutscene == null:
		push_warning("Missing action cutscene node: %s" % cutscene_name)
		return
	await blink_holder.play_close()
	cutscene.visible = true
	blink_holder.play_open()

func _close_to_main_scene() -> void:
	is_closing = true
	can_close_after_release = false

	await blink_holder.play_close()

	visible = false
	_hide_cutscenes()
	is_closing = false

	blink_holder.play_open()

	if main.has_method("do_act_transition"):
		await main.do_act_transition(current_item_name)
	else:
		push_warning("Main is missing do_act_transition")

	current_item_name = ""


func _hide_cutscenes() -> void:
	for child: Node in get_children():
		var cutscene: CanvasItem = child as CanvasItem
		if cutscene != null:
			cutscene.visible = false

extends Control

const ITEM_PATHS := {
	"Water": "Water",
	"Dart": "Dart",
	"Phone": "../Desk/Phone",
	"Animalia": "../Desk/Animalia",
	"Notepad": "../Desk/Notepad",
	"Food": "FoodBowl",
	"Mug": "Mug",
	"Bedroll": "BedRoll",
	"Rifle": "Rifle",
	"FirstAidKit": "FirstAidKit",
	"WoodenPost": "WoodenPost",
	"Rope": "Rope"
}

const PASS_THROUGH_PATHS := [
	".",
	"../Desk",
	"../Outside",
	"../Outside/Wolf",
]

const ITEM_MESSAGES := {
	"Water": "Water",
	"Dart": "Tranquilizer",
	"Food": "Food",
	"Mug": "Mug",
	"Bedroll": "Bedroll",
	"Rifle": "Rifle",
	"FirstAidKit": "First Aid Kit",
	"WoodenPost": "Wooden Post",
	"Phone": "Phone",
	"Animalia": "Animalia",
	"Notepad": "Notepad",
	"Rope": "Rope"
}

const SPECIAL_ITEM_NAMES := [
	"Animalia",
	"Notepad",
]

const ITEM_USE_DESCRIPTIONS := {
	"Water": "give the wolf water?",
	"Dart": "tranquilize the wolf?",
	"Food": "give the wolf food?",
	"Mug": "not do anything?",
	"Bedroll": "build a shelter for the wolf?",
	"Rifle": "shoot the rifle and scare the wolf?",
	"FirstAidKit": "heal the wolf?",
	"WoodenPost": "build a barrier?",
	"Phone": "call wildlife services?",
	"Rope": "trap it?"
}

const HOVER_LABEL_OFFSET := Vector2(16, 16)

@onready var hover_label: Label = $"../HoverLabel"
@onready var open_animalia = $"../../OpenAnimalia"
@onready var open_notebook = $"../../OpenNotebook"

var selected_item := ""
var selected_button: BaseButton


func _ready() -> void:
	hover_label.visible = false
	hover_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	for path: String in PASS_THROUGH_PATHS:
		var control := get_node_or_null(path) as Control
		if control != null:
			control.mouse_filter = Control.MOUSE_FILTER_IGNORE

	for item_name: String in ITEM_PATHS:
		var button := get_node_or_null(ITEM_PATHS[item_name]) as BaseButton
		if button == null:
			push_warning("Missing item button: %s" % item_name)
			continue

		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.z_index = 10
		button.pressed.connect(_on_item_pressed.bind(item_name, button))
		button.mouse_entered.connect(_show_item_name.bind(item_name))
		button.mouse_exited.connect(_hide_item_name)

func _process(_delta: float) -> void:
	if hover_label.visible:
		hover_label.global_position = get_global_mouse_position() + HOVER_LABEL_OFFSET


func _on_item_pressed(item_name: String, button: BaseButton) -> void:
	if item_name == "Animalia":
		tween_item(button)
		clear_selected_item()
		open_animalia.open()
		return

	if item_name == "Notepad":
		tween_item(button)
		clear_selected_item()
		open_notebook.open()
		return

	if selected_button != null:
		selected_button.modulate = Color.WHITE
		selected_button.scale = Vector2.ONE

	if selected_item == item_name:
		selected_item = ""
		selected_button = null
	else:
		selected_item = item_name
		selected_button = button
		selected_button.modulate = Color(1.0, 0.92, 0.45)

	tween_item(button)


func _show_item_name(item_name: String) -> void:
	hover_label.text = ITEM_MESSAGES.get(item_name, item_name)
	hover_label.visible = true


func _hide_item_name() -> void:
	hover_label.visible = false


func has_selected_item() -> bool:
	return selected_item != ""

func tween_item(button: BaseButton) -> void:
	var tween := create_tween()
	tween.tween_property(button, "scale", Vector2(1.08, 1.08), 0.08)
	tween.tween_property(button, "scale", Vector2.ONE, 0.08)

func get_selected_item_use_description() -> String:
	return ITEM_USE_DESCRIPTIONS.get(selected_item, "use this item?")

func selected_item_triggers_warning() -> bool:
	return selected_item != "" and not selected_item in SPECIAL_ITEM_NAMES

func clear_selected_item() -> void:
	if selected_button != null:
		selected_button.modulate = Color.WHITE
		selected_button.scale = Vector2.ONE

	selected_item = ""
	selected_button = null

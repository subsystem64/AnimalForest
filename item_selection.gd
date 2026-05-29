extends Control

const ITEM_PATHS := {
	"Water": "Shelf/Water",
	"Dart": "Shelf/Dart",
	"Phone": "Desk/Phone",
	"Animalia": "Desk/Animalia",
	"Notepad": "Desk/Notepad",
}

const PASS_THROUGH_PATHS := [
	"Shelf",
	"Desk",
	"Outside",
	"Outside/Wolf",
]

const ITEM_MESSAGES := {
	"Water": "Water",
	"Dart": "Tranquilizer",
	"Phone": "Phone",
	"Animalia": "Animalia",
	"Notepad": "Notepad",
}

const HOVER_LABEL_OFFSET := Vector2(16, 16)

@onready var hover_label: Label = $HoverLabel

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

	var tween := create_tween()
	tween.tween_property(button, "scale", Vector2(1.08, 1.08), 0.08)
	tween.tween_property(button, "scale", Vector2.ONE, 0.08)


func _show_item_name(item_name: String) -> void:
	hover_label.text = ITEM_MESSAGES.get(item_name, item_name)
	hover_label.visible = true


func _hide_item_name() -> void:
	hover_label.visible = false

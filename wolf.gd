extends Control

const CLOSE_HITBOX_NAMES := [
	"CloseTopHitbox",
	"CloseBottomHitbox",
	"CloseLeftHitbox",
	"CloseRightHitbox",
]

@onready var wolf_button: Button = $WolfButton
@onready var wolf_closeup: Control = $"../../WolfCloseup"
@onready var item_selection = $"../.."
@onready var warning: Control = $"../../../Warning"
@onready var warning_label: RichTextLabel = $"../../../Warning/WarningLabel"
@onready var yes_button: BaseButton = $"../../../Warning/YesButton"
@onready var no_button: BaseButton = $"../../../Warning/NoButton"


func _ready() -> void:
	wolf_closeup.z_index = 100
	wolf_closeup.mouse_filter = Control.MOUSE_FILTER_STOP
	warning.z_index = 200

	wolf_button.mouse_filter = Control.MOUSE_FILTER_STOP
	wolf_button.pressed.connect(_on_wolf_pressed)

	yes_button.mouse_filter = Control.MOUSE_FILTER_STOP
	yes_button.pressed.connect(_on_warning_yes_pressed)

	no_button.mouse_filter = Control.MOUSE_FILTER_STOP
	no_button.pressed.connect(_on_warning_no_pressed)

	var window_border := wolf_closeup.get_node_or_null("WindowBorder") as Control
	if window_border != null:
		window_border.mouse_filter = Control.MOUSE_FILTER_IGNORE

	for button_name: String in CLOSE_HITBOX_NAMES:
		_connect_closeup_button(button_name)


func _on_wolf_pressed() -> void:
	if item_selection.has_selected_item():
		warning_label.text = "Do you want to %s" % item_selection.get_selected_item_use_description()
		warning.visible = true
		return

	wolf_closeup.visible = true


func _on_closeup_border_pressed() -> void:
	wolf_closeup.visible = false


func _on_warning_yes_pressed() -> void:
	warning.visible = false
	wolf_closeup.visible = true


func _on_warning_no_pressed() -> void:
	warning.visible = false
	item_selection.clear_selected_item()


func _connect_closeup_button(button_name: String) -> void:
	var button := wolf_closeup.find_child(button_name, true, false) as BaseButton
	if button == null:
		return

	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.pressed.connect(_on_closeup_border_pressed)

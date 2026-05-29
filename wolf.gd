extends Control

const CLOSE_HITBOX_NAMES := [
	"CloseTopHitbox",
	"CloseBottomHitbox",
	"CloseLeftHitbox",
	"CloseRightHitbox",
]

const WOLF_TERRITORIAL_NAME := "WolfTerritorial"
const WOLF_HUNGRY_NAME := "WolfHungry"
const WOLF_WOUNDED_NAME := "WolfWounded"

@export_range(0, 2) var level := 0:
	set(value):
		level = clampi(value, 0, 2)
		if is_node_ready():
			_update_wolf_closeup_images()

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
	_update_wolf_closeup_images()

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
	if item_selection.selected_item_triggers_warning():
		warning_label.text = "Do you want to %s" % item_selection.get_selected_item_use_description()
		warning.visible = true
		return

	wolf_closeup.visible = true


func _on_closeup_border_pressed() -> void:
	# _increment_level()
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


func _update_wolf_closeup_images() -> void:
	var territorial_image := _find_closeup_image(WOLF_TERRITORIAL_NAME)
	var hungry_image := _find_closeup_image(WOLF_HUNGRY_NAME)
	var wounded_image := _find_closeup_image(WOLF_WOUNDED_NAME)

	if territorial_image != null:
		territorial_image.visible = level == 0
	if hungry_image != null:
		hungry_image.visible = level == 1
	if wounded_image != null:
		wounded_image.visible = level == 2	


func _find_closeup_image(node_name: String) -> TextureRect:
	return wolf_closeup.find_child(node_name, true, false) as TextureRect


func _increment_level() -> void:
	level = (level + 1) % 3

extends Control

const CLOSE_HITBOX_NAMES := [
	"CloseTopHitbox",
	"CloseBottomHitbox",
	"CloseLeftHitbox",
	"CloseRightHitbox",
]

@onready var wolf_button: Button = $WolfButton
@onready var wolf_closeup: Control = $"../../WolfCloseup"


func _ready() -> void:
	wolf_closeup.z_index = 100
	wolf_closeup.mouse_filter = Control.MOUSE_FILTER_STOP

	wolf_button.mouse_filter = Control.MOUSE_FILTER_STOP
	wolf_button.pressed.connect(_on_wolf_pressed)

	var window_border := wolf_closeup.get_node_or_null("WindowBorder") as Control
	if window_border != null:
		window_border.mouse_filter = Control.MOUSE_FILTER_IGNORE

	for button_name: String in CLOSE_HITBOX_NAMES:
		_connect_closeup_button(button_name)


func _on_wolf_pressed() -> void:
	wolf_closeup.visible = true


func _on_closeup_border_pressed() -> void:
	wolf_closeup.visible = false


func _connect_closeup_button(button_name: String) -> void:
	var button := wolf_closeup.find_child(button_name, true, false) as BaseButton
	if button == null:
		return

	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.pressed.connect(_on_closeup_border_pressed)

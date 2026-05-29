extends Control

@onready var wolf_button: Button = $WolfButton
@onready var wolf_closeup: Control = $"../../WolfCloseup"


func _ready() -> void:
	wolf_button.mouse_filter = Control.MOUSE_FILTER_STOP
	wolf_button.pressed.connect(_on_wolf_pressed)


func _on_wolf_pressed() -> void:
	wolf_closeup.visible = true

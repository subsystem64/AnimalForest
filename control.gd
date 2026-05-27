extends Control

@onready var wolf_button = $Outside/Wolf/WolfButton
@onready var wolf_closeup_layer = $WolfCloseup
@onready var close_background = $WolfCloseup/Background

func _ready():
	wolf_closeup_layer.visible = false
	
	wolf_button.pressed.connect(_on_wolf_button_pressed)
	close_background.gui_input.connect(_on_close_background_clicked)

func _on_wolf_button_pressed():
	wolf_closeup_layer.visible = true

func _on_close_background_clicked(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		wolf_closeup_layer.visible = false

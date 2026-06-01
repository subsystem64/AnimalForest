extends Control

signal epilogue_finished

@onready var epilogue_text: RichTextLabel = $EpilogueText

var full_text := ""
var visible_characters := 0
var type_timer := 0.0
var type_speed := 0.035
var is_typing := false


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP

	epilogue_text.bbcode_enabled = true
	epilogue_text.visible_characters = 0


func show_epilogue(text: String) -> void:
	full_text = text
	visible_characters = 0
	type_timer = 0.0
	is_typing = true

	visible = true
	epilogue_text.text = full_text
	epilogue_text.visible_characters = 0


func _process(delta: float) -> void:
	if not is_typing:
		return

	type_timer += delta

	if type_timer >= type_speed:
		type_timer = 0.0
		visible_characters += 1
		epilogue_text.visible_characters = visible_characters

		if visible_characters >= full_text.length():
			is_typing = false


func _gui_input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_typing:
			finish_typing()
		else:
			epilogue_finished.emit()


func finish_typing() -> void:
	is_typing = false
	visible_characters = full_text.length()
	epilogue_text.visible_characters = visible_characters

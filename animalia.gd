extends Control

const PAGE_COUNT := 5

@onready var next_button: BaseButton = $FlipNext
@onready var previous_button: BaseButton = $FlipPrevious
@onready var close_button: BaseButton = $Close
@onready var page_counter: RichTextLabel = $PageCounter

var page := 1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

	next_button.mouse_filter = Control.MOUSE_FILTER_STOP
	next_button.pressed.connect(_on_next_pressed)

	previous_button.mouse_filter = Control.MOUSE_FILTER_STOP
	previous_button.pressed.connect(_on_previous_pressed)

	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.pressed.connect(_on_close_pressed)

	_update_page_counter()


func open() -> void:
	z_index = 10
	visible = true


func _on_next_pressed() -> void:
	page = min(page + 1, PAGE_COUNT)
	_update_page_counter()


func _on_previous_pressed() -> void:
	page = max(page - 1, 1)
	_update_page_counter()


func _on_close_pressed() -> void:
	visible = false


func _update_page_counter() -> void:
	page_counter.text = "%d/%d" % [page, PAGE_COUNT]

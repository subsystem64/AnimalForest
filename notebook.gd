extends Control

const PAGE_COUNT := 5
@onready var notebook_text: RichTextLabel = $NotebookText
@onready var next_button: BaseButton = $FlipNext
@onready var previous_button: BaseButton = $FlipPrevious
@onready var close_button: BaseButton = $Close
@onready var page_counter: RichTextLabel = $PageCounter

var page_text := [
	"I was born at a very young age.",
	"Neither my mother or my father were present for my birth.",
	"I was raised by a tree",
	"I am wooden.",
	"You're stumped.",
]

var page := 1
var inspection_notes: Array[String] = []


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
	notebook_text.text = page_text[page - 1]


func add_inspection_note(note_name: String) -> void:
	if note_name in inspection_notes:
		return

	inspection_notes.append(note_name)
	page_text[0] += "\n%s" % note_name

	if page == 1:
		_update_page_counter()

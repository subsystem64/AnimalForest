extends Control

signal epilogue_finished

const ENDING_EPILOGUES := {
	"corporate": "[center][b][color=#cfa66a]ENDING — CORPORATE[/color][/b][/center]\n\n" +
	"Phase 3 approved. Cedar Ridge opens the following spring.\n\n" +
	"Wolf pack W-7's tracking collar data goes silent in the summer.\n\n" +
	"The pileated woodpecker nesting zones in Sector 7 are cleared in March.\n\n" +
	"Marcus receives a commendation.",

	"activist": "[center][b][color=#cfa66a]ENDING — ACTIVIST[/color][/b][/center]\n\n" +
	"Phase 3 approved with modifications.\n\n" +
	"Revenue projections revised downward. The wolf corridor stays open.\n\n" +
	"Marcus stays. He sends a polite letter declining the Institute position.\n\n" +
	"Dr. Osei replies: 'The door stays open.'",

	"scientist": "[center][b][color=#cfa66a]ENDING — ANIMAL SCIENTIST[/color][/b][/center]\n\n" +
	"Marcus joins the Cascade Wildlife Policy Institute.\n\n" +
	"Two years later he helps draft the Pacific Northwest Timber Coexistence Standards. Four regional companies adopt them.\n\n" +
	"Hartwell is not among them.\n\n" +
	"Phase 3 was approved six weeks after his departure.\n\n" +
	"Wolf pack W-7 was not seen in Sector 12 the following spring."
}

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


func show_epilogue(ending_id: String) -> void:
	if not ENDING_EPILOGUES.has(ending_id):
		push_warning("Missing epilogue for ending: %s" % ending_id)
		return

	full_text = ENDING_EPILOGUES[ending_id]
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

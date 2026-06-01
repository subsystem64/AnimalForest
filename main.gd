extends Control

signal act_changed(act: int)
signal score_changed(score: int)

const ITEM_ACT_SCORES := {
	"Water":	   [1, 2, 1],
	"Dart": 	   [1, 2, 2],
	"Food":        [1, 3, 1],
	"Mug":         [3, 1, 1],
	"Bedroll":     [1, 2, 2],
	"Rifle":       [2, 2, 1],
	"FirstAidKit": [1, 1, 3],
	"WoodenPost":  [2, 1, 2],
	"Phone": 	   [2, 2, 2],
}

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

const MORNING_BACKGROUND := preload("res://assets/Environment/MorningBackground.png")

@export_range(1, 3) var act := 1:
	set(value):
		var new_act := clampi(value, 1, 4)
		if act == new_act:
			return

		act = new_act
		act_changed.emit(act)

@export var score := 0:
	set(value):
		if score == value:
			return

		score = value
		score_changed.emit(score)

@export var current_act_score := 0

@onready var outside_background: TextureRect = $Control/Outside/OutsideBackground
@onready var phone = $Control/Desk/Phone
@onready var blink_holder = $ActionCutscene/CanvasLayer/BlinkHolder
@onready var epilogue_screen = $EpilogueScreen


func _ready() -> void:
	$Act1Cutscene.start_act1_cutscene()


func _process(delta: float) -> void:
	pass


func advance_level() -> void:
	act = act + 1
	
	if act == 2:
		$Act2Cutscene.start_act2_cutscene()
		await $Act2Cutscene.act_2_cutscene_started
		blink_holder.play_open()
	elif act == 3:
		$Act3Cutscene.start_act3_cutscene()
		await $Act3Cutscene.act_3_cutscene_started
		blink_holder.play_open()


func do_act_transition(item_name: String) -> void:
	var item_score := score_item_for_current_act(item_name)
	current_act_score = item_score
	outside_background.texture = MORNING_BACKGROUND

	if phone.has_method("do_phone_call"):
		var phone_call_started := bool(phone.call("do_phone_call", act, item_score))
		if phone_call_started and phone.has_signal("phone_call_ended"):
			await phone.phone_call_ended
		elif phone_call_started:
			push_warning("Phone is missing phone_call_ended")
	else:
		push_warning("Phone is missing do_phone_call")

	await blink_holder.play_close()

	if act == 3:
		blink_holder.play_open()
		await play_ending_sequence()
	else:
		await advance_level()


func play_ending_sequence() -> void:
	var ending_id := get_ending_id()

	if phone.has_method("do_ending_phone_call"):
		var ending_call_started := bool(phone.call("do_ending_phone_call", ending_id))

		if ending_call_started and phone.has_signal("phone_call_ended"):
			await phone.phone_call_ended
		elif ending_call_started:
			push_warning("Phone is missing phone_call_ended")
	else:
		push_warning("Phone is missing do_ending_phone_call")

	if ENDING_EPILOGUES.has(ending_id):
		epilogue_screen.show_epilogue(ENDING_EPILOGUES[ending_id])
		await epilogue_screen.epilogue_finished
	else:
		push_warning("Missing epilogue for ending: %s" % ending_id)


func score_item_for_current_act(item_name: String) -> int:
	if not item_name in ITEM_ACT_SCORES:
		push_warning("Missing score values for item: %s" % item_name)
		return 0

	var act_scores: Array = ITEM_ACT_SCORES[item_name] as Array
	var score_index := act - 1

	if score_index < 0 or score_index >= act_scores.size():
		push_warning("Missing score value for item %s in act %s" % [item_name, act])
		return 0

	var item_score := int(act_scores[score_index])
	score += item_score
	return item_score


func get_ending_id() -> String:
	if score >= 9:
		return "scientist"
	elif score >= 6:
		return "activist"
	else:
		return "corporate"

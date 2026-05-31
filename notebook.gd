extends Control

@onready var notebook_text: RichTextLabel = $NotebookText
@onready var next_button: BaseButton = $FlipNext
@onready var previous_button: BaseButton = $FlipPrevious
@onready var close_button: BaseButton = $Close
@onready var page_counter: RichTextLabel = $PageCounter

var page := 1
var inspection_notes: Array[String] = []
var unlocked_post_acts: Array[String] = []

var page_text := [
	"Day 1 - Sunday\n\nGot in just before noon today. The cabin's in better shape than I expected after winter - a few things to sort out but nothing urgent. Set up the desk, got the laptop running, made coffee.\n\nSpent the afternoon going through the Q1 numbers and roughing out talking points for tomorrow's presentation. Earnings call is at nine, so I want to be sharp. Reminded myself three times to charge the laptop tonight. Writing it here so I actually do it.\n\nTo do tomorrow: 9am earnings call, follow up with Dale on crew schedules, check the router.",
	"Day 2 - Monday\n\nEarnings call went well. I pitched preliminary expansion as viable - Phase 3 figures look strong on paper, and the board seems to want to hear that they look strong, so that worked out. Now all that's left is the on-site feasibility study and we're good to go!\n\nSpent the rest of the afternoon writing up the summary and sending it through. Corporate wants a more detailed breakdown by end of week, which means tomorrow is going to be mostly desk work. Made pasta for dinner. Forgot to buy sauce so I used olive oil and cheese. It was fine.",
	"Day 3 - Tuesday\n\nFound a mug in the back of the cabinet while I was looking for the spare coffee filters. My parents had it made when I was about sixteen - we had a dog named Cooper, a mutt, showed up at a shelter and never left. He followed me everywhere for thirteen years, and when he passed they gave it to me as a reminder.\n\nI've been in the city since grad school. Never got a dog. Always figured it wasn't fair to the animal - the apartment, the hours, the travel. Sensible decision. I stand by it.\n\nStill. Nice mug.",
	"Day 4 - Wednesday\n\nPhase 3 DFS package came through from corporate today. It's a big one - mapping out new roads, new crews, exploring a section of timberland that hasn't been touched before. Logistically it's going to be a headache, but that's the job.\n\nThis is the kind of project I came up here for, honestly. I spent three years in the Portland office doing coordination work and never once felt like I was making a decision that mattered. Out here it's different. Things actually move when I push them.\n\nNeed to figure out the northern access road situation. That's going to be a sticking point.",
	"Day 5 - Thursday\n\nEnvironmental review meeting today. The company probably paid 500k for a team of petulant, idealistic children to tell me 100 reasons why I'm the problem. If it weren't us paying them right now, they'd probably be standing outside a city hall somewhere blocking some poor bloke's 9am commute.\n\nThey spent a fair amount of time on a wolf pack that apparently occupies part of the proposed expansion zone. Pack of about eleven, been in that corridor hassling the crew for a few years. Irritating beasts to say the least. BUT... silver linings - I asked whether it was a regulatory issue. They said not technically, as long as we stay within the thresholds. So. There you go.",
	"Day 6 - Friday\n\nOut with the survey team today along the northern edge of the zone. Long day on foot. The biologists pointed out wolf signs - tracks, a couple of old kills, a possible den site maybe 200 metres off the planned route. They were pretty animated about it. I took notes.\n\nIt's real land. I know that sounds obvious. It looks different when you're standing in it versus looking at a map in a conference room. One of those trees would probably run my house for years. Anyway. The route still makes sense from an operational standpoint, and the environmental assessment cleared it. Sent the end-of-week report to Portland tonight, should be done with the study in a week or two.",
	"Day 7 - Saturday\n\nDay off. Went into town with a few of the crew for dinner and a couple of beers. Dale's got a theory about every piece of equipment on site and will tell you all of them if you let him. I let him. It was a good evening.\n\nDrove back with the window down. It's properly dark out here - no streetlights, no ambient glow from the city. I keep forgetting what that's like. Sat on the porch for a while before going in. Quiet. Really quiet."
]

var post_act_entries := {
	1: {
		"correct": {
			"day": "Day 8",
			"title": "After Act I",
			"text": "Wolf showed up tonight. Big one - been circling the perimeter for the better part of an hour before I noticed it. I turned off the floodlight and just watched it through the window.\n\nIt finished its circuit and left. Didn't rush. Didn't look back.\n\nI've been reading the field notes that were left in the cabin. Territorial behavior, apparently. It wasn't threatening me. It was just letting me know it knew I was here.\n\nI think I knew that, watching it. I just sat still and let it finish what it was doing.\n\nNot sure why I'm writing this down. It just felt like the kind of thing worth remembering."
		},
		"mediocre": {
			"day": "Day 8",
			"title": "After Act I",
			"text": "Wolf was outside tonight. Circling - territorial thing, apparently, according to the field notes someone left here. I got it to back off. It left eventually.\n\nProbably fine. These things happen out here.\n\nStill. It was bigger than I expected."
		},
		"wrong": {
			"day": "Day 8",
			"title": "After Act I",
			"text": "Wolf situation outside tonight. Handled it. Called it in to James, told him to make sure the crew knows to keep their distance.\n\nLast thing I need right now is wildlife disruptions with Phase 3 moving forward. I've got enough on my plate.\n\nAnyway. Early start tomorrow."
		}
	},
	2: {
		"correct": {
			"day": "Day 9",
			"title": "After Act II",
			"text": "It came back. Same wolf, I'm almost certain - same size, same way of moving. This time it was watching me eat through the window. Just standing there in the dark.\n\nI left some food on the sill and moved back from the glass. It took almost twenty minutes, but it came up and took it. Kept its eyes on me the whole time.\n\nI didn't move.\n\nI keep thinking about the survey walk on Friday. The biologists said the planned route cuts through territory the pack has been using for years. I put that in my report as a note, but I didn't push it.\n\nNot sure what I would have pushed it toward anyway."
		},
		"mediocre": {
			"day": "Day 9",
			"title": "After Act II",
			"text": "Wolf again tonight. Looked hungry - could see its ribs a little, which I wasn't expecting. Left some food out. It didn't come close enough to take it, but it hung around for a while.\n\nCalled it in. Someone will deal with it.\n\nThink I need to get more coffee filters. Also call Portland back about the northern access road."
		},
		"wrong": {
			"day": "Day 9",
			"title": "After Act II",
			"text": "Wolf was back. Dealt with it. It's becoming a pattern which is going to be a problem if it keeps up - can't have wildlife hanging around the operational area, especially not with the crew due to arrive next week.\n\nI'll flag it in the morning report. Probably a habitat pressure thing from the survey zone. Which is all the more reason to get Phase 3 sorted quickly and get proper boundaries established.\n\nLong day. Bed."
		}
	},
	3: {
		"correct": {
			"day": "Day 10",
			"title": "After Act III",
			"text": "I went outside.\n\nI know how that sounds. I'm not sure I can explain the reasoning in a way that holds up, because it doesn't really hold up - it was growling, it was hurt, those two things don't go together cleanly and I knew that going out there.\n\nBut I've seen it twice now. And the way it was standing - body turned away, not squared up - that's not how you stand if you're about to attack someone. I've read enough of those field notes to know that much.\n\nIt let me get close. It let me bandage up its leg.\n\nI have a meeting in the city tomorrow. Phase 3. I've been trying to figure out what I'm going to say since I got the call. I still don't know.\n\nI keep thinking: if I can read this, what else have I been not reading?"
		},
		"mediocre": {
			"day": "Day 10",
			"title": "After Act III",
			"text": "Wolf came back tonight. Hurt this time - bad leg, not putting weight on it. I called wildlife services and they said they'd send someone in the morning.\n\nI watched it through the window for a while after I hung up. It didn't move much.\n\nMeeting in the city tomorrow. Phase 3 finalization. I should sleep.\n\nIf it's still there in the morning they can probably help it. Oh well..."
		},
		"wrong": {
			"day": "Day 10",
			"title": "After Act III",
			"text": "Wolf showed up again tonight. Looked aggressive, maybe even rabid. I didn't go out.\n\nI've got the Phase 3 meeting tomorrow and I'm not going to jeopardise that or myself over this. Wildlife services can handle it if it becomes a problem.\n\nPacked up. Early start.\n\nI think I heard it outside for a while after I went to bed. Or maybe that was the wind. Hard to tell out here. I'm just hoping it leaves before I wake up."
		}
	}
}


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
	_update_page_counter()


func _on_next_pressed() -> void:
	page = min(page + 1, page_text.size())
	_update_page_counter()


func _on_previous_pressed() -> void:
	page = max(page - 1, 1)
	_update_page_counter()


func _on_close_pressed() -> void:
	visible = false


func _update_page_counter() -> void:
	page = clampi(page, 1, page_text.size())

	page_counter.text = "%d/%d" % [page, page_text.size()]
	notebook_text.text = page_text[page - 1]
	notebook_text.scroll_to_line(0)

	previous_button.disabled = page <= 1
	next_button.disabled = page >= page_text.size()


func add_inspection_note(note_message: String, note_page: int) -> void:
	while page_text.size() < note_page:
		page_text.append("")

	var note_key := "%d:%s" % [note_page, note_message]

	if note_key in inspection_notes:
		return

	inspection_notes.append(note_key)

	page_text[note_page - 1] += "\n• %s" % note_message

	_update_page_counter()

func unlock_post_act_entry(act_number: int, result_type: String) -> void:
	result_type = result_type.to_lower()

	if not post_act_entries.has(act_number):
		push_warning("No post-act journal entry for Act %d" % act_number)
		return

	if not post_act_entries[act_number].has(result_type):
		push_warning("No '%s' post-act result for Act %d" % [result_type, act_number])
		return

	for key in unlocked_post_acts:
		if key.begins_with("%d:" % act_number):
			return

	var unlock_key := "%d:%s" % [act_number, result_type]
	unlocked_post_acts.append(unlock_key)

	var entry = post_act_entries[act_number][result_type]

	var formatted_entry := "[center]%s - %s[/center]\n\n%s" % [
		entry["day"],
		entry["title"],
		entry["text"]
	]

	page_text.append(formatted_entry)

	page = page_text.size()
	_update_page_counter()

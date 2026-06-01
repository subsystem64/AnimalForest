extends Control

const PAGE_TEXT := [
	"[center][b][font_size=28]THE ANIMALIA[/font_size][/b][/center]\n" +
	"[center][i]Field Reference: Gray Wolf  (Canis lupus)[/i][/center]\n\n" +
	"This handbook is a reference guide to wolf behaviour, body language, and the situational factors that shape both.\n\n" +
	"It is not a decoder. Wolf signals do not carry single fixed meanings. They carry possibilities, shaped by context.\n\n" +
	"[color=#a97a45][b]Sections[/b][/color]\n" +
	"• Behaviour\n" +
	"• Body Language\n" +
	"• Threats & Human Conduct\n\n" +
	"[i]The most dangerous assumption a person can make about a wild animal is that they have read it correctly.[/i]",

	"[center][b][font_size=24]A NOTE ON CERTAINTY[/font_size][/b][/center]\n\n" +
	"This handbook documents what research supports. It does not document certainty.\n\n" +
	"Wolf signals describe probabilities, not guarantees. A wolf displaying one signal is more likely than not to be communicating something, but it is not certain.\n\n" +
	"Context shifts probability. History between observer and animal shifts it further.\n\n" +
	"[i]The second most dangerous assumption is that, because you cannot read it perfectly, you should not try.[/i]",

	"[center][b][font_size=24]BEHAVIOUR — TERRITORY[/font_size][/b][/center]\n\n" +
	"[color=#a97a45][b]Territorial Patrolling[/b][/color]\n" +
	"Wolves maintain large territories and are highly territorial creatures.\n\n" +
	"• Slow, wide arc at a consistent distance from a structure or boundary:\n" +
	"[color=#6f7f4f]Territorial assertion.[/color]\n\n" +
	"• Increasing patrol frequency near a boundary:\n" +
	"Often signals a perceived threat.\n\n" +
	"• Patrol with direct observation of a human or structure:\n" +
	"Information gathering.",

	"[center][b][font_size=24]BEHAVIOUR — VOCAL SIGNALS[/font_size][/b][/center]\n\n" +
	"[color=#a97a45][b]Howling[/b][/color]\n" +
	"Howling is the wolf's primary long-distance communication. It can carry information about location, pack size, and emotional state.\n\n" +
	"• Sustained, melodic howl from a distance:\n" +
	"Social or locating behaviour.\n\n" +
	"• Shorter defensive howl:\n" +
	"Warning pack members of a threat.\n\n" +
	"[color=#a97a45][b]Growling[/b][/color]\n" +
	"Growl duration is a key indicator of intent.\n\n" +
	"• Sustained growl:\n" +
	"[color=#6f7f4f]Dominance or pre-aggression warning.[/color]\n\n" +
	"• Broken growl:\n" +
	"Defensive vocalisation, common in cornered or frightened animals.",

	"[center][b][font_size=24]BEHAVIOUR — APPROACH[/font_size][/b][/center]\n\n" +
	"[color=#a97a45][b]Direct Human Contact[/b][/color]\n" +
	"Wolves rarely approach humans voluntarily. Repeated contact may make a wolf approach with more familiarity.\n\n" +
	"• Slow approach with frequent pauses, body angled:\n" +
	"[color=#6f7f4f]Cautious investigation. Not aggression.[/color]\n\n" +
	"• Approach that stops at a fixed distance:\n" +
	"The wolf has established the boundary between its territory and yours.\n\n" +
	"[color=#a97a45][b]Food-Seeking Behaviour[/b][/color]\n" +
	"A calorie-deficient wolf may move closer to human structures.\n\n" +
	"• Sustained gaze fixed on food:\n" +
	"Foraging signal.\n\n" +
	"• Growling, intense gaze fixed on a human:\n" +
	"Possible hunting signal.",

	"[center][b][font_size=24]BODY LANGUAGE — TAIL & EARS[/font_size][/b][/center]\n\n" +
	"[color=#a97a45][b]Tail Position[/b][/color]\n" +
	"• Held high and stiff:\n" +
	"Confidence or dominance.\n\n" +
	"• Hanging loosely at mid-height:\n" +
	"Neutral or relaxed.\n\n" +
	"• Held low but not tucked:\n" +
	"Submission or reduced confidence.\n\n" +
	"• Fully tucked beneath the belly:\n" +
	"Fear, extreme submission, or pain.\n\n" +
	"• Horizontal and rigid:\n" +
	"Hunting posture or focused aggression.\n\n" +
	"[color=#a97a45][b]Ear Position[/b][/color]\n" +
	"• Pricked forward, upright:\n" +
	"Alert and engaged.\n\n" +
	"• Pulled back flat:\n" +
	"Fear or pain.",

	"[center][b][font_size=24]BODY LANGUAGE — FACE & EYES[/font_size][/b][/center]\n\n" +
	"[color=#a97a45][b]Eye Contact[/b][/color]\n" +
	"• Sustained direct eye contact:\n" +
	"Status assertion or predatory assessment.\n\n" +
	"• Sustained eye contact with body partially turned away:\n" +
	"Often seen in animals that are in pain or distress.\n\n" +
	"• Averted gaze, head lowered:\n" +
	"Submission or non-confrontational signal.\n\n" +
	"[color=#a97a45][b]Facial Expression[/b][/color]\n" +
	"• Lips pulled back to expose teeth:\n" +
	"Dominant threat or possible predatory behaviour.\n\n" +
	"• Lips relaxed, mouth slightly open:\n" +
	"No threat being communicated.\n\n" +
	"• Lips pulled back with ears flat:\n" +
	"Fear-based defensive display.",

	"[center][b][font_size=24]THREATS & HUMAN CONDUCT[/font_size][/b][/center]\n\n" +
	"[color=#a97a45][b]Habitat Loss[/b][/color]\n" +
	"Logging, road construction, and land clearance can displace wolves and compress them into remaining habitat near human work areas.\n\n" +
	"[color=#a97a45][b]Prey Scarcity[/b][/color]\n" +
	"When development reduces prey availability, wolves may expand their range and move closer to human structures.\n\n" +
	"[color=#a97a45][b]Injured Animal[/b][/color]\n" +
	"Pain produces defensive body language: flattened ears, tucked tail, low growl. These can closely resemble a threat display.\n\n" +
	"[i]Long-term coexistence begins with design, not incident management.[/i]"
]

@onready var animalia_text: RichTextLabel = $AnimaliaText
@onready var next_button: BaseButton = $FlipNext
@onready var previous_button: BaseButton = $FlipPrevious
@onready var close_button: BaseButton = $Close
@onready var page_counter: RichTextLabel = $PageCounter

var page := 1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

	animalia_text.bbcode_enabled = true
	animalia_text.scroll_active = true
	animalia_text.fit_content = false

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
	page = min(page + 1, PAGE_TEXT.size())
	_update_page_counter()


func _on_previous_pressed() -> void:
	page = max(page - 1, 1)
	_update_page_counter()


func _on_close_pressed() -> void:
	visible = false


func _update_page_counter() -> void:
	page = clampi(page, 1, PAGE_TEXT.size())

	page_counter.text = "%d/%d" % [page, PAGE_TEXT.size()]
	animalia_text.text = PAGE_TEXT[page - 1]
	animalia_text.scroll_to_line(0)

	previous_button.disabled = page <= 1
	next_button.disabled = page >= PAGE_TEXT.size()

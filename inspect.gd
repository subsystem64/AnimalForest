extends Control

const MAGNIFYING_GLASS_OFFSET := Vector2(-30, -30)
const SCRIBBLE_SOUND_VOLUME_DB := +24.0

const ACT_NOTE_PAGES := {
	1: 8,
	2: 10,
	3: 12,
}

const INSPECTION_MESSAGES := {
	1: {
		"Tail": "Tail straight up. Cooper was like that with other dogs… especially that yippity little chihuahua down the road.",
		"Ears": "Ears forward. Almost like it can hear me thinking.",
		"Eyes": "It keeps looking directly at me. Not moving, not blinking. That can't be good.",
		"ArcWalk": "It's walking in a circuit. Same radius every time. Like it's drawing a line.",
		"Mouth": "Not making a sound. At least it’s not angry…",
	},
	2: {
		"Head": "Head lower than last time. Whole posture is different. Hmm…",
		"Tail": "Tail down. Not tucked under, just... hanging. Like it's tired.",
		"Eyes": "It's looking at what I'm eating. Has been since I noticed it. Not looking at me. Looking at the food.",
		"Ribs": "Can see its ribs a little. Not badly, but enough. It's lean.",
		"Mouth": "Still not making noise, but it feels less ominous today.",
	},
	3: {
		"Leg": "Something's wrong with the back leg.",
		"Back": "Whole body's pulled inward. Like it's trying to make itself smaller.\nIt's not facing me straight on. Body's turned slightly away. This is unusual…",
		"Ears": "Ears flat to its head. Coop never did that... Handbook should know.",
		"Tail": "Tail tucked? That’s the fear one right?",
		"Mouth": "It's growling. Low, continuous. It's just... standing there, growling, not moving. That’s not scary at all…",
	}
}

@onready var magnifying_glass: TextureRect = $MagnifyingGlass
@onready var scribble_sound: AudioStreamPlayer = $ScribbleSound
@onready var notebook = $"../../OpenNotebook"
@onready var main = $"../.."

var inspection_polygons: Array[CollisionPolygon2D] = []
var hovered_polygon: CollisionPolygon2D
var was_mouse_pressed := false
var can_collect_after_release := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	magnifying_glass.mouse_filter = Control.MOUSE_FILTER_IGNORE
	magnifying_glass.visible = false
	scribble_sound.volume_db = SCRIBBLE_SOUND_VOLUME_DB

	for child in find_children("*", "CollisionPolygon2D", true, false):
		inspection_polygons.append(child as CollisionPolygon2D)


func _process(_delta: float) -> void:
	var is_mouse_pressed := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if not is_visible_in_tree():
		was_mouse_pressed = is_mouse_pressed
		can_collect_after_release = false
		hide_magnifying_glass()
		return

	if not is_mouse_pressed:
		can_collect_after_release = true

	hovered_polygon = _get_hovered_inspection_polygon()
	magnifying_glass.visible = hovered_polygon != null

	if magnifying_glass.visible:
		magnifying_glass.global_position = get_global_mouse_position() + MAGNIFYING_GLASS_OFFSET

	if hovered_polygon != null and is_mouse_pressed and not was_mouse_pressed and can_collect_after_release:
		_collect_hovered_inspection()
		can_collect_after_release = false

	was_mouse_pressed = is_mouse_pressed


func hide_magnifying_glass() -> void:
	magnifying_glass.visible = false


func _get_hovered_inspection_polygon() -> CollisionPolygon2D:
	var mouse_position := get_global_mouse_position()

	for collision_polygon: CollisionPolygon2D in inspection_polygons:
		if not collision_polygon.is_visible_in_tree():
			continue

		var local_mouse_position := collision_polygon.get_global_transform().affine_inverse() * mouse_position

		if Geometry2D.is_point_in_polygon(local_mouse_position, collision_polygon.polygon):
			return collision_polygon

	return null


func _collect_hovered_inspection() -> void:
	var note_area := hovered_polygon.get_parent()
	var note_area_name := note_area.name
	var act_number: int = main.act

	if not ACT_NOTE_PAGES.has(act_number):
		push_warning("No note page set for act %d" % act_number)
		return

	var note_page: int = ACT_NOTE_PAGES[act_number]

	var note_message := _get_note_message(act_number, note_area_name)

	inspection_polygons.erase(hovered_polygon)
	scribble_sound.play()
	notebook.add_inspection_note(note_message, note_page)
	hide_magnifying_glass()


func _get_note_message(act_number: int, note_area_name: String) -> String:
	if not INSPECTION_MESSAGES.has(act_number):
		push_warning("No inspection messages for act %d" % act_number)
		return note_area_name

	if not INSPECTION_MESSAGES[act_number].has(note_area_name):
		push_warning("No inspection message for '%s' in act %d" % [note_area_name, act_number])
		return note_area_name

	return INSPECTION_MESSAGES[act_number][note_area_name]

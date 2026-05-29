extends TextureRect

const MAGNIFYING_GLASS_OFFSET := Vector2(-13, -13)

@onready var magnifying_glass: TextureRect = $"../MagnifyingGlass"
@onready var notebook = $"../../../OpenNotebook"

var inspection_polygons: Array[CollisionPolygon2D] = []
var hovered_polygon: CollisionPolygon2D
var was_mouse_pressed := false
var can_collect_after_release := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	magnifying_glass.mouse_filter = Control.MOUSE_FILTER_IGNORE
	magnifying_glass.visible = false

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
		var local_mouse_position := collision_polygon.get_global_transform().affine_inverse() * mouse_position
		if Geometry2D.is_point_in_polygon(local_mouse_position, collision_polygon.polygon):
			return collision_polygon

	return null


func _collect_hovered_inspection() -> void:
	var note_name := hovered_polygon.get_parent().name
	inspection_polygons.erase(hovered_polygon)
	notebook.add_inspection_note(note_name)
	hide_magnifying_glass()

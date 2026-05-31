extends Control

const BLINK_SPEED := 10.0
const DEFAULT_ANIMATION := "default"
const CLOSE_ANIMATION := "close"
const OPEN_ANIMATION := "open"
const CLOSE_END_FRAME := 5
const OPEN_START_FRAME := 10

@onready var blink: AnimatedSprite2D = $BlinkAnimation
@onready var blink_layer: CanvasLayer = get_parent() as CanvasLayer

func _ready() -> void:
	blink_layer.visible = false
	visible = false
	blink.visible = false
	if blink.sprite_frames != null:
		_ensure_split_animations()

	resized.connect(_resize_blink)
	_resize_blink()


func play_transition() -> void:
	await play_close()
	await play_open()


func play_close() -> void:
	await _play_animation(CLOSE_ANIMATION, false)


func play_open() -> void:
	await _play_animation(OPEN_ANIMATION, true)


func _play_animation(animation_name: StringName, hide_when_finished: bool) -> void:
	blink_layer.visible = true
	visible = true
	blink.visible = true
	blink.stop()
	blink.animation = animation_name
	blink.frame = 0
	blink.play()

	await blink.animation_finished

	if hide_when_finished:
		blink_layer.visible = false
		visible = false
		blink.visible = false


func _ensure_split_animations() -> void:
	var frames: SpriteFrames = blink.sprite_frames
	var default_frame_count := frames.get_frame_count(DEFAULT_ANIMATION)
	if default_frame_count == 0:
		return

	_rebuild_animation(CLOSE_ANIMATION, 0, mini(CLOSE_END_FRAME, default_frame_count - 1))
	_rebuild_animation(OPEN_ANIMATION, mini(OPEN_START_FRAME, default_frame_count - 1), default_frame_count - 1)


func _rebuild_animation(animation_name: StringName, start_frame: int, end_frame: int) -> void:
	var frames: SpriteFrames = blink.sprite_frames
	if not frames.has_animation(animation_name):
		frames.add_animation(animation_name)
	else:
		frames.clear(animation_name)

	frames.set_animation_loop(animation_name, false)
	frames.set_animation_speed(animation_name, BLINK_SPEED)

	for frame_index in range(start_frame, end_frame + 1):
		var texture := frames.get_frame_texture(DEFAULT_ANIMATION, frame_index)
		var duration := frames.get_frame_duration(DEFAULT_ANIMATION, frame_index)
		frames.add_frame(animation_name, texture, duration)


func _resize_blink() -> void:
	blink.centered = false
	blink.position = Vector2.ZERO

	var frames: SpriteFrames = blink.sprite_frames
	if frames == null:
		return

	var texture: Texture2D = frames.get_frame_texture(blink.animation, 0)
	if texture == null:
		return

	var target_size: Vector2 = size
	var image_size: Vector2 = texture.get_size()

	blink.scale = target_size / image_size

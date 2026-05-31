extends Control

const BLINK_SPEED := 10.0

@onready var blink: AnimatedSprite2D = $BlinkAnimation
@onready var blink_layer: CanvasLayer = get_parent() as CanvasLayer

func _ready() -> void:
	blink_layer.visible = false
	visible = false
	blink.visible = false
	if blink.sprite_frames != null:
		blink.sprite_frames.set_animation_loop(blink.animation, false)
		blink.sprite_frames.set_animation_speed(blink.animation, BLINK_SPEED)

	resized.connect(_resize_blink)
	_resize_blink()


func play_transition() -> void:
	blink_layer.visible = true
	visible = true
	blink.visible = true
	blink.stop()
	blink.frame = 0
	blink.play()

	await blink.animation_finished

	blink_layer.visible = false
	visible = false
	blink.visible = false


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

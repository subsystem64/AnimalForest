extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AntSprite.play("idle")
	$Sprite2D.visible = false
	
	

func _mouse_enter() -> void:
	$AntSprite.play("walk")
	$Sprite2D.visible = true

func _mouse_exit() -> void:
	$AntSprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

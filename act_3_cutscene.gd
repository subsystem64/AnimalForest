extends Node

signal act_3_cutscene_started

@onready var outside_view: TextureRect = $"../Control/Outside/OutsideBackground"
@onready var growl_sound: AudioStreamPlayer = $"WoundedWolfGrowl"

var cutscene_played := false
var final_wounded := preload("res://assets/WoundedWolf/WoundedWolfThemed.png")


func start_act3_cutscene() -> void:
	if cutscene_played:
		return

	cutscene_played = true


	# Small pause before the light kicks on.
	growl_sound.play()
	await get_tree().create_timer(1).timeout
	emit_signal("act_3_cutscene_started")
	# Stabilize on the final hungry wolf background.
	outside_view.texture = final_wounded
	await get_tree().create_timer(0.8).timeout
	growl_sound.stop()

extends Node

signal act_2_cutscene_started

@onready var outside_view: TextureRect = $"../Control/Outside/OutsideBackground"

var cutscene_played := false
var final_hungry := preload("res://assets/HungryWolf/HungaryWolfThemed.png")


func start_act2_cutscene() -> void:
	if cutscene_played:
		return
	
	cutscene_played = true


	# Small pause before the light kicks on.
	await get_tree().create_timer(0.8).timeout

	
	emit_signal("act_2_cutscene_started")
	# Stabilize on the final hungry wolf background.
	outside_view.texture = final_hungry

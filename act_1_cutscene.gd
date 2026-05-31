extends Node

@onready var outside_view: TextureRect = $"../Control/Outside/OutsideBackground"
@onready var floodlight_sound: AudioStreamPlayer = $"FloodlightSound"
@onready var flicker_sound: AudioStreamPlayer = $"FlickerSound"

var cutscene_played := false

var floodlight_off := preload("res://assets/TerritorialWolf/FloodlightOff.png")

var flicker_frames := [
	preload("res://assets/TerritorialWolf/FloodlightFrame1.png"),
	preload("res://assets/TerritorialWolf/FloodlightFrame2.png"),
	preload("res://assets/TerritorialWolf/FloodlightFrame3.png"),
	preload("res://assets/TerritorialWolf/FloodlightFrame4.png"),
]

var final_territorial := preload("res://assets/TerritorialWolf/TerritorialWolf.png")


func start_act1_cutscene() -> void:
	if cutscene_played:
		return

	cutscene_played = true

	# Start with floodlights off.
	outside_view.texture = floodlight_off

	# Small pause before the light kicks on.
	await get_tree().create_timer(0.8).timeout

	# Flicker on/off while showing wolf circling.
	await flicker_sequence()

	# Stabilize on the final territorial wolf background.
	outside_view.texture = final_territorial


func flicker_sequence() -> void:
	flicker_sound.play()
	# First harsh flickers.
	outside_view.texture = flicker_frames[0]
	await get_tree().create_timer(0.08).timeout

	outside_view.texture = floodlight_off
	await get_tree().create_timer(0.12).timeout

	outside_view.texture = flicker_frames[1]
	await get_tree().create_timer(0.10).timeout

	outside_view.texture = floodlight_off
	await get_tree().create_timer(0.07).timeout

	outside_view.texture = flicker_frames[2]
	await get_tree().create_timer(0.15).timeout

	outside_view.texture = floodlight_off
	await get_tree().create_timer(0.10).timeout

	# More stable now, wolf has moved around the arc.
	outside_view.texture = flicker_frames[3]
	await get_tree().create_timer(0.45).timeout

	outside_view.texture = floodlight_off
	await get_tree().create_timer(0.08).timeout

	outside_view.texture = flicker_frames[0]
	await get_tree().create_timer(0.25).timeout
	outside_view.texture = floodlight_off
	await get_tree().create_timer(0.6).timeout
	flicker_sound.stop()
		# Floodlight sound.
	floodlight_sound.play()

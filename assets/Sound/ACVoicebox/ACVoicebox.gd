extends AudioStreamPlayer
class_name ACVoiceBox

signal characters_sounded(characters: String)
signal finished_phrase

const PITCH_MULTIPLIER_RANGE := 0.3
const INFLECTION_SHIFT := 0.4

@export var base_pitch := 3.5

const sounds := {
	"a": preload("res://assets/Sound/ACVoicebox/sounds/a.wav"),
	"b": preload("res://assets/Sound/ACVoicebox/sounds/b.wav"),
	"c": preload("res://assets/Sound/ACVoicebox/sounds/c.wav"),
	"d": preload("res://assets/Sound/ACVoicebox/sounds/d.wav"),
	"e": preload("res://assets/Sound/ACVoicebox/sounds/e.wav"),
	"f": preload("res://assets/Sound/ACVoicebox/sounds/f.wav"),
	"g": preload("res://assets/Sound/ACVoicebox/sounds/g.wav"),
	"h": preload("res://assets/Sound/ACVoicebox/sounds/h.wav"),
	"i": preload("res://assets/Sound/ACVoicebox/sounds/i.wav"),
	"j": preload("res://assets/Sound/ACVoicebox/sounds/j.wav"),
	"k": preload("res://assets/Sound/ACVoicebox/sounds/k.wav"),
	"l": preload("res://assets/Sound/ACVoicebox/sounds/l.wav"),
	"m": preload("res://assets/Sound/ACVoicebox/sounds/m.wav"),
	"n": preload("res://assets/Sound/ACVoicebox/sounds/n.wav"),
	"o": preload("res://assets/Sound/ACVoicebox/sounds/o.wav"),
	"p": preload("res://assets/Sound/ACVoicebox/sounds/p.wav"),
	"q": preload("res://assets/Sound/ACVoicebox/sounds/q.wav"),
	"r": preload("res://assets/Sound/ACVoicebox/sounds/r.wav"),
	"s": preload("res://assets/Sound/ACVoicebox/sounds/s.wav"),
	"t": preload("res://assets/Sound/ACVoicebox/sounds/t.wav"),
	"u": preload("res://assets/Sound/ACVoicebox/sounds/u.wav"),
	"v": preload("res://assets/Sound/ACVoicebox/sounds/v.wav"),
	"w": preload("res://assets/Sound/ACVoicebox/sounds/w.wav"),
	"x": preload("res://assets/Sound/ACVoicebox/sounds/x.wav"),
	"y": preload("res://assets/Sound/ACVoicebox/sounds/y.wav"),
	"z": preload("res://assets/Sound/ACVoicebox/sounds/z.wav"),
	"th": preload("res://assets/Sound/ACVoicebox/sounds/th.wav"),
	"sh": preload("res://assets/Sound/ACVoicebox/sounds/sh.wav"),
	" ": preload("res://assets/Sound/ACVoicebox/sounds/blank.wav"),
	".": preload("res://assets/Sound/ACVoicebox/sounds/longblank.wav")
}

var remaining_sounds: Array = []


func _ready() -> void:
	finished.connect(play_next_sound)


func play_string(in_string: String) -> void:
	remaining_sounds.clear()
	parse_input_string(in_string)
	play_next_sound()


func stop_voice() -> void:
	remaining_sounds.clear()
	stop()


func play_next_sound() -> void:
	if remaining_sounds.is_empty():
		finished_phrase.emit()
		return

	var next_symbol: Dictionary = remaining_sounds.pop_front()
	characters_sounded.emit(next_symbol["characters"])

	if next_symbol["sound"] == "":
		play_next_sound()
		return

	var sound: AudioStream = sounds[next_symbol["sound"]]
	pitch_scale = base_pitch + (PITCH_MULTIPLIER_RANGE * randf())

	if next_symbol["inflective"]:
		pitch_scale += INFLECTION_SHIFT

	stream = sound
	play()


func parse_input_string(in_string: String) -> void:
	for word in in_string.split(" "):
		parse_word(word)
		add_symbol(" ", " ", false)


func parse_word(word: String) -> void:
	if word.is_empty():
		return

	var skip_char := false
	var is_inflective := word.ends_with("?")

	for i in range(word.length()):
		if skip_char:
			skip_char = false
			continue

		if i < word.length() - 1:
			var two_character_substring := word.substr(i, 2).to_lower()

			if sounds.has(two_character_substring):
				add_symbol(two_character_substring, word.substr(i, 2), is_inflective)
				skip_char = true
				continue

		var single_char := word[i].to_lower()

		if sounds.has(single_char):
			add_symbol(single_char, word[i], is_inflective)
		else:
			add_symbol("", word[i], false)


func add_symbol(sound: String, characters: String, inflective: bool) -> void:
	remaining_sounds.append({
		"sound": sound,
		"characters": characters,
		"inflective": inflective
	})

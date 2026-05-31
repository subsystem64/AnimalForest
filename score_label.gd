extends Label

@onready var main = $"../.."


func _ready() -> void:
	if main.has_signal("score_changed"):
		main.score_changed.connect(_on_score_changed)
	else:
		push_warning("Main is missing score_changed")

	_on_score_changed(main.score)


func _on_score_changed(score: int) -> void:
	text = "Score: %s" % score

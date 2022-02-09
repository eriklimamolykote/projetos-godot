extends Node

var score = 0 setget set_score

signal score_changed

func _ready():
	pass

func add_score(val):
	score += val
	emit_signal("score_changed")
	
func set_score(val):
	print("Cant write score. Use function 'add_score'")
	pass

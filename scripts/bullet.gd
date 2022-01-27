extends Area2D


var vel = 400
var dir = Vector2(0, -1) setget set_dir


func _ready():
	pass

func _process(delta):
	translate(dir * vel * delta)
	

func _on_notifier_screen_exited():
	#print("queue_free")
	queue_free()
	
func set_dir(val):
	dir = val
	rotation = dir.angle()

extends Area2D

var vel = 400
var dir = Vector2()
var damage = 1

onready var initpos = self.global_position

func _physics_process(delta):
	translate(dir * vel * delta)
	if global_position.distance_to(initpos) > 150:
		autodestroy()
		
func _on_machinegunBullet_body_entered(body):
	queue_free()

func _on_machinegunBullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage, self)
		autodestroy()

func autodestroy():
	queue_free()

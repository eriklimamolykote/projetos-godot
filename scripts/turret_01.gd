extends StaticBody2D

var bodies = []
var rot_vel = PI * .5 #PI = 3,1415

const PRE_BULLET = preload("res://scenes/turret_01_bullet.tscn")

func _ready():
	pass
	
func _process(delta):
	if bodies.size():
		var angle = $cannon.get_angle_to(bodies[0].global_position)
		if abs(angle) > .1:
			$cannon.rotation += rot_vel * delta *  sign(angle)
		#$cannon.look_at(bodies[0].global_position)	

func _on_sensor_body_entered(body):
	bodies.append(body)

func _on_sensor_body_exited(body):
	var index = bodies.find(body)
	if index >= 0:
		bodies.remove(index)

func _on_shoot_timer_timeout():
	var bullet = PRE_BULLET.instance()
	bullet.global_position = $cannon.global_position
	bullet.dir = Vector2(cos($cannon.rotation), sin($cannon.rotation))
	get_parent().add_child(bullet)
	

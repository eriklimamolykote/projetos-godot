tool
extends StaticBody2D

var bodies = []
var rot_vel = PI * .5 #PI = 3,1415
export(float, 0, 360) var start_rot = 0.0 setget set_start_rot

const PRE_BULLET = preload("res://scenes/turret_01_bullet.tscn")

func _ready():
	pass
	
func _process(delta):
	if bodies.size():
		var angle = $cannon.get_angle_to(bodies[0].global_position)
		if abs(angle) > .1:
			$cannon.rotation += rot_vel * delta *  sign(angle)
		if $cannon/sight.is_colliding():
			if $cannon/sight.get_collider() != bodies[0]:
				var oldBody = bodies[0]
				var newBodyIndex = bodies.find($cannon/sight.get_collider())
				bodies[0] = $cannon/sight.get_collider()
				bodies[newBodyIndex] = oldBody	
				
func _draw():
	$cannon.rotation = deg2rad(start_rot)				
		
func _on_sensor_body_entered(body):
	if !bodies.size():
		$shoot_timer.start()
		bodies.append(body)
		$cannon/sight.enabled = true
	
func _on_sensor_body_exited(body):
	var index = bodies.find(body)
	if index >= 0:
		bodies.remove(index)
	if !bodies.size():
		$cannon/sight.enabled = false
		$shoot_timer.stop()
		$cannon/smoke.emitting = false	

func _on_shoot_timer_timeout():
	if $cannon/sight.is_colliding():
		shoot()
	else:
		$cannon/smoke.emitting = false	

func shoot():
	$cannon/smoke.emitting = true
	$cannon_anim.play("shoot")
	$stream_shoot.play()
	var bullet = PRE_BULLET.instance()
	bullet.global_position = global_position
	bullet.dir = Vector2(cos($cannon.rotation), sin($cannon.rotation))
	get_parent().add_child(bullet)	

func set_start_rot(val):
	start_rot = val
	if Engine.editor_hint:
		update()

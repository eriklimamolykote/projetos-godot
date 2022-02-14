extends Area2D

var rot_vel = PI
var vel = 100
var target
var homing = false

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	homing = true

func _process(delta):
	if target:
		if homing:
			var angle = get_angle_to(target.global_position)
			if abs(angle) > .01:
				rotation = rot_vel * delta * sign(angle)
		translate(Vector2(cos(rotation), sin(rotation)).normalized() * vel * delta)		


func _on_home_missile_body_entered(body):
	destroy()


func _on_area_damage_destroid():
	destroy()
	#queue_free()

func destroy():
	$area_damage.queue_free()
	$sprite.hide()
	$shape.queue_free()
	set_process(false)
	$smoke.emitting = false
	$fire.emitting = true
	$explosion.play("boom")
	yield(get_tree().create_timer(2), "timeout")
	queue_free()

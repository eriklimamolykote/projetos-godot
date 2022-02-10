extends Area2D
const PRE_MISSILE = preload("res://scenes/home_missile.tscn")
var rot_vel = PI * .1 #PI = 3,1415

func _ready():
	pass

func get_target():
	var tank = get_parent().bodies[0]
	var ht = (tank.global_position - global_position).normalized()
	var facing = Vector2(cos(rotation), sin(rotation))
	
	if ht.dot(facing) > .0:
		if $fire_timer.is_stopped():
			fire()
			$fire_timer.start()
	else:
		$fire_timer.stop()	
	
	return null
	
func fire():
	if get_parent().bodies.size():
		var missile = PRE_MISSILE.instance()
		get_parent().add_Child(missile)
		missile.rotation = rotation
		missile.target = get_parent().bodies[0]
		missile.global_position = $barrel.global_position
	else:
		$fire_timer.stop()	

func _on_fire_timer_timeout():
	fire()

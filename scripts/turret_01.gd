tool
extends StaticBody2D

var bodies = []
var rot_vel = PI * .5 #PI = 3,1415
export(float, 0, 360) var start_rot = 0.0 setget set_start_rot

export(float, 100, 1000) var sensor_radius = 100 setget set_sensor_radius

const PRE_BULLET = preload("res://scenes/turret_01_bullet.tscn")

var first_draw = true
export var life = 100

onready var init_life = life
onready var game = get_node("/root/GAME")

var dead = false

func _ready():
	#print(init_life)
	pass
	
func _process(delta):
	if bodies.size():
		var angle = $cannon.get_angle_to(bodies[0].global_position)
		if abs(angle) > .01:
			$cannon.rotation += rot_vel * delta *  sign(angle)
		if $cannon/sight.is_colliding():
			if $cannon/sight.get_collider() != bodies[0]:
				var oldBody = bodies[0]
				var newBodyIndex = bodies.find($cannon/sight.get_collider())
				bodies[0] = $cannon/sight.get_collider()
				bodies[newBodyIndex] = oldBody	
				
func _draw():
	if dead:
		return
	if first_draw:
		$cannon.rotation = deg2rad(start_rot)
		var new_shape = CircleShape2D.new()
		new_shape.radius = sensor_radius
		$sensor/shape.shape = new_shape
		$cannon/sight.cast_to = Vector2(sensor_radius, 0)
		if !Engine.editor_hint:
			first_draw = false
	if bodies.size():
		draw_circle(Vector2(), $sensor/shape.shape.radius, Color(1, 0, 0, .1))	
	draw_circle_arc(Vector2(), $sensor/shape.shape.radius, 0, 360, Color(1, 0, 0, .5))
	first_draw = false			
		
func _on_sensor_body_entered(body):
	if !bodies.size():
		$shoot_timer.start()
		bodies.append(body)
		$cannon/sight.enabled = true
		update()
	
func _on_sensor_body_exited(body):
	var index = bodies.find(body)
	if index >= 0:
		bodies.remove(index)
	if !bodies.size():
		$cannon/sight.enabled = false
		$shoot_timer.stop()
		$cannon/smoke.emitting = false
	update()		

func _on_shoot_timer_timeout():
	if $cannon/sight.is_colliding():
		shoot()
	else:
		$cannon/smoke.emitting = false	

func shoot():
	$cannon/smoke.emitting = true
	$cannon_anim.play("shoot")
	$stream/stream_shoot.play()
	var bullet = PRE_BULLET.instance()
	bullet.global_position = global_position
	bullet.dir = Vector2(cos($cannon.rotation), sin($cannon.rotation))
	bullet.max_dist = sensor_radius
	get_parent().add_child(bullet)	

func set_start_rot(val):
	start_rot = val
	if Engine.editor_hint:
		update()
		
func set_sensor_radius(val):
	sensor_radius = val
	if Engine.editor_hint:
		update()		
		
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points+1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		var point = center + Vector2(cos(deg2rad(angle_point)), sin(deg2rad(angle_point))) * radius
		points_arc.push_back(point)
		
	for indexPoint in range(nb_points):
		print(indexPoint, points_arc[indexPoint], points_arc[indexPoint+1])
		draw_line(points_arc[indexPoint], points_arc[indexPoint+1], color)
	pass				

func _on_weak_spot_damage(damage, node):
	life -= damage
	$stream/stream_hit.play()
	$hp_bar_node/hp_bar.scale = float(life) / float(init_life)
	if life <= 0:
		set_process(false)
		$cannon.queue_free()
		$sensor.disconnect("body_exited", self, "_on_sensor_body_exited")
		$sensor.queue_free()
		$shoot_timer.queue_free()
		$weak_spot.queue_free()
		$hp_bar_node/hp_bar.queue_free()
		dead = true
		update()
		$explosion/anim.play("explode")
		$stream/stream_explosion.play()
		get_tree().call_group("camera", "shake", 5, 1)
		game.add_score(250)

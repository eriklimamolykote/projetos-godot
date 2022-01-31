extends Area2D

const MAX_DIST = 250

var vel = 400
var dir = Vector2(0, -1) setget set_dir
onready var init_pos = global_position

var live = true

func _ready():
	pass

func _process(delta):
	
	if live:
		if global_position.distance_to(init_pos) >= MAX_DIST:
			autodestroy()
		translate(dir * vel * delta)
	
func _on_notifier_screen_exited():
	#print("queue_free")
	queue_free()
	
func set_dir(val):
	dir = val
	rotation = dir.angle()


func _on_bullet_body_entered(body):
	if body.collision_layer == 3: #colisão com muro (wall)
		autodestroy()
		
func autodestroy():
	$smoke.emitting = false
	live = false
	$sprite.visible = false
	$anim_self_destruction.play("explode")
	call_deferred("set_monitoring", false)
	#monitoring = false
	call_deferred("set_monitorable", false)
	#monitorable = false
	yield($anim_self_destruction, "animation_finished")
	queue_free()		

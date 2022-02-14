tool
extends KinematicBody2D

onready var BULLET_TANK_GROUP = "bullet-" + str(self)

# PI = 180 graus
const ROT_VEL = PI / 2
const dead_zone = 0.02
const MAX_SPEED = 100
var pre_bullet = preload("res://scenes/bullet.tscn")
var pre_track = preload("res://scenes/track.tscn")
var pre_mg_bullet = preload("res://scenes/mg_bullet.tscn")
var accel = 0
var can_mouse_look = false
var travel = 0
var loaded = true

signal cannon_shooted
signal hmg_shooted

export(int, "bigRed", "blue", "dark", "darLarge", "green", "huge", "red", "sand") var bodie = 0 setget set_bodie
export(int, "tankBlue", "tankDark", "tankGreen", "tankRed", "tankSand", "specialBarrel2", "specialBarrel2_outline", "specialBarrel5_outline") var barrel = 4 setget set_barrel

var bodies = [
	"res://sprites/tankBody_bigRed.png",     # 0
	"res://sprites/tankBody_blue.png",       # 1
	"res://sprites/tankBody_dark.png",       # 2
	"res://sprites/tankBody_darkLarge.png",  # 3
	"res://sprites/tankBody_green.png",      # 4
	"res://sprites/tankBody_hug.png",        # 5
	"res://sprites/tankBody_red.png",        # 6
	"res://sprites/tankBody_sand.png"        # 7
]

var barrels = [
	"res://sprites/tankBlue_barrel1_outline.png",
	"res://sprites/tankDark_barrel1_outline.png",
	"res://sprites/tankGreen_barrel1_outline.png",
	"res://sprites/tankRed_barrel1_outline.png",
	"res://sprites/tankSand_barrel1_outline.png",
	"res://sprites/specialBarrel2.png",
	"res://sprites/specialBarrel2_outline.png",
	"res://sprites/specialBarrel5_outline.png"
]


func _ready():
	pass
	
func _draw():
	$Sprite.texture = load(bodies[bodie])
	$barrel/sprite.texture = load(barrels[barrel])

func _input(event):
	if event is InputEventMouseMotion:
		can_mouse_look = true

func _physics_process(delta):
	
	if Engine.editor_hint:
		return
	
	var vel_mod = 1
	
	if get_tree().get_nodes_in_group(str(self) + "-oil").size() > 0:
		vel_mod = .3
	
#	var dir_x = 0
#	var dir_y = 0
#
#	if Input.is_action_pressed("ui_right"):
#		dir_x += 1
#
#	if Input.is_action_pressed("ui_left"):
#		dir_x -= 1	
#
#	if Input.is_action_pressed("ui_up"):
#		dir_y -= 1
#
#	if Input.is_action_pressed("ui_down"):
#		dir_y += 1
#
	if Input.is_action_just_pressed("ui_shoot") and loaded:
#		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 6:
		var bullet = pre_bullet.instance()
		bullet.global_position = $barrel/muzzle.global_position # coloca a bala na posição da ponta do canhão
		bullet.dir = Vector2(cos($barrel.global_rotation), sin($barrel.global_rotation) ).normalized()
		bullet.add_to_group(BULLET_TANK_GROUP)
		bullet.max_dist = $barrel/sight.position.x - $barrel/muzzle.position.x
		bullet.shooter = self
		$"../".add_child(bullet)
		$barrel/anim.play("fire")
		loaded = false
		$barrel/sight.update()
		$timer_reload.start()
		$barrel/barrel_anim.play("shoot")
		#get_parent().add_child(bullet)
		emit_signal("cannon_shooted")
		
	if Input.is_action_just_pressed("machinegun"):
		shoot_mg()
		$timer_mg.start()
		
	if Input.is_action_just_released("machinegun"):
		$timer_mg.stop()	
#
#	look_at(get_global_mouse_position())		
#
#	move_and_slide( Vector2(dir_x, dir_y) * speed )	

	var rot = 0
	
	var dir = 0
	
	if Input.is_action_pressed("ui_right"):
		rot += 1
		
	if Input.is_action_pressed("ui_left"):
		rot -= 1
		
	if rot == 0:
		rot =  Input.get_joy_axis(0, JOY_AXIS_0)		
		
	if Input.is_action_pressed("ui_up"):
		dir +=1
		
	if Input.is_action_pressed("ui_down"):
		dir -= 1 
		
	if dir == 0:
		dir = -Input.get_joy_axis(0, JOY_AXIS_1)			
		
	rotate(ROT_VEL * rot * delta)
	
	#if dir != 0:
	accel = lerp(accel, MAX_SPEED * dir, .03)
	#else:
		#accel = lerp(accel, 0, .05)	
	
	#print(accel)	
	
	var move = move_and_slide(Vector2( cos(rotation), sin(rotation) ) * accel * vel_mod)
	
	travel += move.length() * delta
	
	if travel > $Sprite.texture.get_size().y:
		travel = 0
		var track = pre_track.instance()
		track.global_position = global_position - Vector2( cos(rotation), sin(rotation) ).normalized() * 5
		track.rotation = rotation
		track.z_index = z_index - 1
		$"../".add_child(track)
	
	var r_hor_axis = Input.get_joy_axis(0, JOY_AXIS_2)
	
	if abs(r_hor_axis) < dead_zone:
		r_hor_axis = 0
		
	var r_ver_axis = Input.get_joy_axis(0, JOY_AXIS_3)		
	
	if abs(r_ver_axis) < dead_zone:
		r_ver_axis = 0
		
	if r_hor_axis != 0 or r_ver_axis != 0:
		
		var vector = Vector2(r_hor_axis, r_ver_axis)
		
		if vector.length() > .95:
			$barrel.global.rotation = vector.normalized().angle()
			can_mouse_look = false

	if can_mouse_look:
		$barrel.look_at(get_global_mouse_position())	
				
func set_bodie(val):
	bodie = val
	if Engine.editor_hint:
		update()
		
func set_barrel(val):
	barrel = val
	if Engine.editor_hint:
		update()
		
func _on_timer_reload_timeout():
	loaded = true
	$barrel/sight.update()

func shoot_mg():
	var mg = pre_mg_bullet.instance()
	mg.global_position = $mg_muzzle.global_position
	mg.global_rotation = global_rotation
	mg.dir = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	mg.shooter = self
	get_parent().add_child(mg)
	emit_signal("hmg_shooted")


func _on_timer_mg_timeout():
	shoot_mg()


func _on_damage_area_destroid():
	queue_free()

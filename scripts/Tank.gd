tool
extends KinematicBody2D

onready var BULLET_TANK_GROUP = "bullet-" + str(self)

var speed = 100
var pre_bullet = preload("res://scenes/bullet.tscn")

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
	

func _process(delta):
	
	if Engine.editor_hint:
		return
	
	var dir_x = 0
	var dir_y = 0
	
	if Input.is_action_pressed("ui_right"):
		dir_x += 1
		
	if Input.is_action_pressed("ui_left"):
		dir_x -= 1	
		
	if Input.is_action_pressed("ui_up"):
		dir_y -= 1
		
	if Input.is_action_pressed("ui_down"):
		dir_y += 1
		
	if Input.is_action_just_pressed("ui_shoot"):
		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 6:
			var bullet = pre_bullet.instance()
			bullet.global_position = $barrel/muzzle.global_position # coloca a bala na posição da ponta do canhão
			bullet.dir = Vector2(cos(rotation), sin(rotation) ).normalized()
			bullet.add_to_group(BULLET_TANK_GROUP)
			$"../".add_child(bullet)
			$barrel/anim.play("fire")
			#get_parent().add_child(bullet)
			
			
	look_at(get_global_mouse_position())		
					
	move_and_slide( Vector2(dir_x, dir_y) * speed )	
	
func set_bodie(val):
	bodie = val
	if Engine.editor_hint:
		update()
		
func set_barrel(val):
	barrel = val
	if Engine.editor_hint:
		update()		


extends ColorRect

onready var init_ret_size = rect_size
var scale = 1 setget set_scale

var vertical = false

func _ready():
	#self.scale = .5
	if init_ret_size.y > init_ret_size.x:
		vertical = true
		rect_rotation = 180
		rect_position = rect_size
	
func _draw():
	draw_rect(Rect2(Vector2(), init_ret_size), Color(0, .6, 0), false)	

func set_scale(val):
	scale = val
	if vertical:
		rect_size.y = init_ret_size.y * scale
	else:	
		rect_size.x = init_ret_size.x * scale 

extends StaticBody2D

const PRE_FRAGMENTS = preload("res://scenes/fragments/crate_box_fragments.tscn")

func _ready():
	$area_obstacle.connect("hitted", self, "on_area_hitted")
	$area_obstacle.connect("destroid", self, "on_area_destroid")
	
func on_area_hitted(damage, health, node):
	if damage > 5:
		$anim.play("bg_hit")
	else:
		$anim.play("small_hit")	

func on_area_destroid():
	var fragments = PRE_FRAGMENTS.instance()
	fragments.global_position = global_position
	fragments.scale = scale
	get_parent().add_child(fragments)
	queue_free()
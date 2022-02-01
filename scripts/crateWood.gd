extends StaticBody2D

func _ready():
	$area_obstacle.connect("hitted", self, "on_area_hitted")
	$area_obstacle.connect("destroid", self, "on_area_destroid")
	
func on_area_hitted(damage, health, node):
	pass 

func on_area_destroid():
	queue_free()

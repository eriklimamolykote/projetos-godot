extends Node2D

func _ready():
	for c in get_children():
		c.connect("tree_exited", self, "on_fragment_tree_exited")
	
func on_fragment_tree_exited():
	if get_child_count() <= 3:
		queue_free()	

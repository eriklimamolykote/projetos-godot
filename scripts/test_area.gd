extends Node

func _ready():
	randomize()
	$home_missile.target = $Tank

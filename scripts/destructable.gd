extends Area2D

signal hitted(damage, health, node)
signal destroid()

export var health = 30

func hit(damage, node):
	health -= damage
	emit_signal("hitted", damage, health, node)
	if health <= 0:
		emit_signal("destroid")

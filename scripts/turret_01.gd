extends StaticBody2D

func _ready():
	pass

func _on_sensor_body_entered(body):
	print(body)

func _on_sensor_body_exited(body):
	print(body)

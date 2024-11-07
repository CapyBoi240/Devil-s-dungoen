extends Node

@onready var camera = get_parent()
var time = 0

func _shake(duration := 0.8, magnitude := 8):
	while time < duration:
		time += get_process_delta_time()
		time = min(time, duration)
		var offset = Vector2()
		offset.x = randf_range(-magnitude, magnitude)
		offset.y = randf_range(-magnitude, magnitude)
		camera.set_offset(offset)
		await get_tree().process_frame
		#Linija 14 pravi OZBILJNE probleme sa pause menijem
		#POPRAVITI ODMAH
	time = 0
	camera.set_offset(Vector2.ZERO)

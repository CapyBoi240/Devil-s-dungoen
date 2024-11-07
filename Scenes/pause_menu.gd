extends Control

@onready var main = $"../../"

func _process(delta: float) -> void:
	pass


func _on_button_4_pressed() -> void:
	get_tree().quit()


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Engine.time_scale = 1


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
	Engine.time_scale = 1


func _on_button_pressed() -> void:
	main.pauseMenu()

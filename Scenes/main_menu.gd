extends Control




func _on_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 2)
	tween.tween_interval(1)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()

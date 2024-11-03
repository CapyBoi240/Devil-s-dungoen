extends Control






func _on_option_button_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_h_slider_2_value_changed(value):
	GlobalWorldEnvironment.environment.adjustment_brightness = value


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

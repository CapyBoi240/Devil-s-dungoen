extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0)
	tween.tween_interval(1)
	tween.tween_property(self, "modulate:a", 1, 3)
	tween.tween_interval(1)
	tween.tween_property(self, "modulate:a", 0, 2)
	tween.tween_interval(1)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	pass # Replace with function body.

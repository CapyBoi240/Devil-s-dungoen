extends Area2D

@export var speed : float = 1400
@onready var ray_cast = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Move the bullet every frame
func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

# Change animation frame shortly after entering the physics process
func _physics_process(delta):
	await get_tree().create_timer(0.005).timeout
	$AnimatedSprite2D.frame = 1
	set_physics_process(false)
	var collider = ray_cast.get_collider()
	
	if collider != null and collider.is_in_group("Environment"):
		queue_free()
# Remove the bullet when it exits the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_area_entered(area):
	if area.name == "Area2D":
		queue_free()
		area.get_parent().health -= 1


func _on_body_entered(body):
	if body.is_in_group("Environment"):
		queue_free()

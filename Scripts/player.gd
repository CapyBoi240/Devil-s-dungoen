extends CharacterBody2D

@export var inv: Inv #"Rendula type comment", "Jimmy baštovan"
# Exported variables
@export var move_speed: float = 200 # Movement speed of the player
@export var stamina: float = 180 # Stamina of the player
@export var max_stamina: float = 180 # Maximum stamina
@export var sprint_multiplier: float = 1.4 # Multiplies speed when sprinting
@export var dash_speed: float = 450 # Speed during dash

# References to other nodes
@onready var gun_pick_up = preload("res://Objects/gun_pick_up.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@onready var screen_shake = get_parent().get_node("Camera2D/ScreenShake")
@onready var camera = get_parent().get_node("Camera")

# Variables
var dash_duration: float = 2.0 # Duration of the dash
var is_dashing: bool = false # Indicates if the player is currently dashing
var stamina_regen_rate: float = 10.0 # Stamina regeneration rate
var stamina_drain_rate: float = 30.0 # Stamina drain rate while sprinting
var gun = null  # The player's current gun
var is_sprinting: bool = false # Indicates if the player is currently sprinting
var dash_direction: Vector2 = Vector2.ZERO # Direction of the dash
var last_vector : Vector2
func _ready():
	camera.smoothing_distance = 5
	
func _physics_process(delta):
	# Get input direction and normalize it
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	# Flip the sprite based on the movement direction
	if Input.is_action_just_pressed("left"):
		animated_sprite.flip_h = true
	elif Input.is_action_just_pressed("right"):
		animated_sprite.flip_h = false
	
	# Set velocity of the player based on the direction and speed
	velocity = direction * move_speed
	
	# Determine if the player should sprint
	if Input.is_action_pressed("sprint") and stamina >= 40 and direction != Vector2.ZERO:
		is_sprinting = true
	elif stamina <= 0 or not Input.is_action_pressed("sprint") or direction == Vector2.ZERO:
		is_sprinting = false
	
	# Check if the player should dash
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_duration == 2.0 and direction != Vector2.ZERO:
		is_dashing = true
		dash_direction = direction

	# Handle dashing logic
	if is_dashing:
		is_sprinting = false
		velocity = dash_direction * dash_speed
		dash_duration -= 10 * delta
		move_and_slide()
		if dash_duration <= 0:
			is_dashing = false
	else:
		dash_duration += delta
		dash_duration = min(2.0, dash_duration)
	
	# Increase speed if sprinting
	if is_sprinting:
		velocity *= sprint_multiplier
		stamina -= stamina_drain_rate * delta
		stamina = max(stamina, 0)
	else:
		stamina += stamina_regen_rate * delta
		stamina = min(stamina, max_stamina)
	
	# Play appropriate animations
	if direction != Vector2.ZERO:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	var mouse_pos = get_global_mouse_position()

	# Move the player
	move_and_slide()

# Function to pick up a new gun
func pick_up_gun(new_gun):
	if gun:
		gun.copy_stats_from(new_gun)  # Copy stats from the new gun if player already has a gun
	else:
		gun = new_gun
		add_child(gun)
		gun.global_position.x = self.global_position.x
		gun.global_position.y = self.global_position.y + 12
		camera.follow = get_node("Gun/CameraMarker")

extends CharacterBody2D

var speed = 100
var target = null
var health = 3
var last_player_position : Vector2
var player_spotted = false

@onready var sprite = $Sprite2D
@onready var navigation_agent = $NavigationAgent2D
@onready var los = $RayCast2D

enum STATES {
	IDLE,
	CHASE,
	ATTACK,
	HIT,
	DEAD
}

var current_state = STATES.IDLE

func _ready():
	# Defer the setup call to ensure the physics frame is ready
	call_deferred("setup")
	
func setup():
	# Get the player node as the target
	target = get_parent().get_node("Player")
	await get_tree().physics_frame

func _physics_process(delta):
	# Check if the enemy is dead
	if health <= 0:
		queue_free()
	
	if target:
		# Update the line of sight to look at the player
		los.look_at(target.global_position)
		check_for_player()
		
	# Handle state-based behavior
	match current_state:
		STATES.IDLE:
			handle_idle()
		STATES.CHASE:
			handle_chase()

func handle_idle():
	# Idle behavior: play idle animation
	sprite.play("idle")

func handle_chase():
	# Chase behavior
	if player_spotted:
		navigation_agent.target_position = target.global_position
	else:
		navigation_agent.target_position = last_player_position

	if not navigation_agent.is_navigation_finished():
		# Calculate the velocity towards the next path position
		var current_position = global_position
		var next_position = navigation_agent.get_next_path_position()
		velocity = current_position.direction_to(next_position) * speed
		move_and_slide()

		# Update sprite animations and movement based on player visibility
		if next_position[0] < position.x:
			sprite.flip_h = true
		elif next_position[0] > position.x:
			sprite.flip_h = false

		sprite.play("run")
	else:
		if not player_spotted:
			# Transition to IDLE state if player is not spotted and navigation is finished
			current_state = STATES.IDLE

func check_for_player():
	# Check if the line of sight ray hits the player
	var collider = los.get_collider()
	if collider:
		if collider == target:
			player_spotted = true
			last_player_position = target.global_position
			# Transition to CHASE state if player is spotted
			current_state = STATES.CHASE
			return true
		
	# Player is not spotted
	player_spotted = false
	return false

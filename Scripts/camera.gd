extends Camera2D

#Variables
@export var follow : Node2D
@export var smoothing_enabled : bool 
@export_range(1, 10) var smoothing_distance : int = 1

var weight

func _ready():
	# Calculate weight based on smoothing distance
	weight = float(11 - smoothing_distance) / 100
	
func _physics_process(delta):
	if follow != null:
		var camera_position : Vector2
		
		# Calculate camera position with or without smoothing
		if smoothing_enabled:
			# Smoothly interpolate between current position and target position
			camera_position = lerp(global_position, follow.global_position, weight)
		else:
			# Directly follow the target position without smoothing
			camera_position = follow.global_position
			
		# Set the camera's global position, using floor() to snap to integer coordinates
		global_position = camera_position.floor()

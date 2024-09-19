extends Sprite2D

var bullet = preload("res://Objects/bullet.tscn")

@onready var screen_shake = get_parent().get_parent().get_node("Camera/ScreenShake")
@onready var camera = get_parent().get_parent().get_node("Camera")
@onready var muzzle = $Muzzle
var can_fire = true
var is_reloading = false

# Export variables to customize in the editor
@export var sprite : String
@export var fire_rate : float = 0.5
@export var mag_size : int = 69
@export var mag : int = 5
@export var reload_time : float = 2
@export var bullet_speed : float = 1200
@export var bullets_per_shot : int = 5
@export var recoil : float = 4
@export var spread_angle = [-10, -5, 0, 5, 10]
@export var shake_magnitude : float = 5
@export var shake_time : float = 0.09
@export var muzzle_x : float
@export var muzzle_y : float

func _ready():
	camera.smoothing_distance = 3
	mag = mag_size

func _physics_process(delta):
	muzzle.position.x = muzzle_x
	muzzle.position.y = muzzle_y
	texture = ResourceLoader.load(sprite)
	if not is_reloading:  # Check if the gun isn't currently reloading
		#Shoot if the shoot button is pressed
		if Input.is_action_pressed("shoot") and can_fire and mag > 0:
			shoot()
			mag -= 1
			can_fire = false
			waiting()
			
		#Reloads the gun
		if Input.is_action_just_pressed("reload") and mag < mag_size:
			reload()
			
		if mag == 0:
			reload()
	
	#Rotates the gun towards the mouse
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	#Flips the gun's sprite
	if mouse_pos.x < get_parent().position.x:
		flip_v = true
	else:
		flip_v = false

func waiting():
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
#Function that reloads the gun
func reload():
	is_reloading = true
	can_fire = false
	await get_tree().create_timer(reload_time).timeout
	mag = mag_size
	can_fire = true
	is_reloading = false

#Function that shoots
func shoot():
	for i in range(bullets_per_shot):
		var bullet_instance = bullet.instantiate() #Creates the bullet
		get_parent().add_child(bullet_instance) #Adds bullet as a child to gun
		bullet_instance.global_position = muzzle.global_position #Changes bullet's position
		screen_shake._shake(shake_time, shake_magnitude) #Shakes the camera
		if bullets_per_shot > 1: #Shotguns
			var spread_index = i % spread_angle.size()
			var spread = spread_angle[spread_index]
			bullet_instance.rotation = rotation + deg_to_rad(spread)
		else: #Other guns
			var rec = randf_range(-recoil, recoil)
			bullet_instance.rotation = rotation + deg_to_rad(rec)
		bullet_instance.speed = bullet_speed
# Function to copy stats from another gun
func copy_stats_from(other_gun):
	muzzle_y = other_gun.muzzle_y
	muzzle_x = other_gun.muzzle_x
	sprite = other_gun.sprite
	fire_rate = other_gun.fire_rate
	mag_size = other_gun.mag_size
	mag = other_gun.mag
	reload_time = other_gun.reload_time
	bullet_speed = other_gun.bullet_speed
	bullets_per_shot = other_gun.bullets_per_shot
	recoil = other_gun.recoil
	spread_angle = other_gun.spread_angle
	shake_magnitude = other_gun.shake_magnitude
	shake_time = other_gun.shake_time

extends Sprite2D

#Preloads the gun
var gun = preload("res://Objects/gun.tscn")

#Variables that will be copied
@export var sprite : String
@export var fire_rate : float = 0.5
@export var mag_size : int = 69
@export var mag : int = 5
@export var reload_time : float = 2
@export var bullet_speed : float = 1200
@export var bullets_per_shot : int = 5
@export var recoil : float = 4
@export var spread_angle = [0]
@export var shake_magnitude : float = 5
@export var shake_time : float = 0.09
@export var muzzle_x : float = 14
@export var muzzle_y : float = 0

func _ready():
	texture = ResourceLoader.load(sprite)
#If there is collision with the player create the gun and copy the stats
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		var new_gun = gun.instantiate() #Creates the gun
		#Copies the stats
		new_gun.sprite = sprite 
		new_gun.muzzle_y = muzzle_y
		new_gun.muzzle_x = muzzle_x
		new_gun.fire_rate = fire_rate
		new_gun.mag_size = mag_size
		new_gun.mag = mag
		new_gun.reload_time = reload_time
		new_gun.bullet_speed = bullet_speed
		new_gun.bullets_per_shot = bullets_per_shot
		new_gun.recoil = recoil
		new_gun.spread_angle = spread_angle
		new_gun.shake_magnitude = shake_magnitude
		new_gun.shake_time = shake_time

		body.pick_up_gun(new_gun)
		queue_free()

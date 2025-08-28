extends CharacterBody3D

@export var walkSpeed = 7
@export var runSpeed = 12



func _physics_process(_delta):
	move_and_slide()
	
func initialize(start_position, player_position):
	
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI/4, PI/4))
	
	velocity = Vector3.FORWARD * walkSpeed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

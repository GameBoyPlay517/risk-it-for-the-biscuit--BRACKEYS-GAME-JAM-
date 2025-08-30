extends CharacterBody3D

@export var walkSpeed = 4.5
@export var runSpeed = 12

@onready var navAgent = $NavigationAgent3D

var inRadius = false

func update_target_position(target_location):
	navAgent.set_target_position(target_location)

func _physics_process(_delta):
	if inRadius:
		var current_location = global_transform.origin
		var next_location = navAgent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * walkSpeed
		velocity = velocity.move_toward(new_velocity, .25)
	
	
	move_and_slide()
	
#func initialize(start_position, player_position):
	
	#look_at_from_position(start_position, player_position, Vector3.UP)
	#rotate_y(randf_range(-PI/4, PI/4))
	
	#velocity = Vector3.FORWARD * walkSpeed
	#velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_navigation_agent_3d_target_reached() -> void:
	print('In Range')


func _on_fov_body_entered(body: Node3D) -> void:
	print("Player in radius")
	inRadius = true
	


func _on_fov_body_exited(body: Node3D) -> void:
	print("Player has left")
	inRadius = false # Replace with function body.

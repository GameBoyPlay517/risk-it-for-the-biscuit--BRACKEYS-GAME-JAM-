extends CharacterBody3D

@export var speed = 8
@export var fall_acceleration = 980
@export var mouse_sensitivity = 0.002
@export var maxStamina = 1.75


@onready var camera = $pivot/Camera3D
#@onready var sprintBar = $UI/TextureProgressBar

var target_velocity = Vector3.ZERO
var showCursor
var canTilt = true
var canSprint 
var tilt = 0.0
var normalScale = scale.y
const  RAY_LENGTH = 1000.0
var originalSpeed = speed 
var crouchSpeed = speed/3 
var sprintSpeed = speed * 3
var stamina = maxStamina

func _ready(): 
	add_to_group("Player")
	showCursor = false
	canSprint = true
	#sprintBar.max_value = maxStamina
	#sprintBar.value = maxStamina
	
	

func _physics_process(delta):
	var direction = Vector3.ZERO
	var input_dir = Vector3()
	
	target_velocity.x = direction.x * speed
	target_velocity.y = direction.y * speed

	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_back"):
		input_dir.z += 1
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("escape"):
		if showCursor:
			showCursor = false
		else:
			showCursor = true
	
	if input_dir.x < 0: 
		tilt = lerp(tilt, 0.1, 5.0 * delta)
	elif input_dir.x > 0: 
		tilt = lerp(tilt, -0.1, 5.0 * delta)
	else: 
		tilt = lerp(tilt, 0.0, 5.0 * delta)
	
	
	if is_on_floor():
		if Input.is_action_pressed("lean_right"):
			tilt = lerp(tilt, -0.95, 5.0 * delta)
		elif Input.is_action_pressed("lean_left"):
			tilt = lerp(tilt, 0.95, 5.0 * delta)
		else:
			tilt = lerp(tilt, 0.0, 5.0 * delta)

		$pivot.rotation.z = deg_to_rad(25) * tilt

		if Input.is_action_pressed("crouch"):
			scale.y = lerp(scale.y, normalScale / 2, 5.0 * delta)
			speed = crouchSpeed 
			#print(speed)
		elif Input.is_action_pressed("sprint") and Input.is_action_pressed("move_forward") and canSprint:
			speed = sprintSpeed
			scale.y = lerp(scale.y, normalScale + .5, 5.0 * delta)
			stamina -= 1 * delta
			stamina = clamp(stamina, 0, maxStamina)
			#sprintBar.value = stamina
			if stamina == 0:
				canSprint = false
			#print(speed) 
		else:
			scale.y = lerp(scale.y, normalScale, 5.0 * delta)
			speed = originalSpeed
			stamina += 1 * delta
			stamina = clamp(stamina, 0, maxStamina)
			#sprintBar.value = stamina
			if stamina == maxStamina:
				canSprint = true
			#print(speed)
		
		#$pivot.rotation.z = lerp_angle($pivot.rotation.z, deg_to_rad(-5), 2 * delta)
	
	if input_dir != Vector3.ZERO:
		input_dir = input_dir.normalized()
	
	direction = (global_transform.basis * input_dir).normalized()
	
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity = target_velocity
	move_and_slide()
	
func _input(event):
	
	if showCursor: 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$pivot.rotation.x = clamp($pivot.rotation.x, -1.2,1.2)
	

signal hit

func die():
	hit.emit()
	queue_free()

func _on_hitbox_body_entered(body):
	print("hittingObject..")
	die()
	
	pass # Replace with function body.

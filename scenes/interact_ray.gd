extends RayCast3D

@onready var prompt = $Prompt
@onready var diffuseBar = $Prompt/TextureProgressBar
var maxDiffuseTime = 3.5
var currentDiffuseTime = 0;

func _on_ready():
	diffuseBar.value = currentDiffuseTime
	diffuseBar.max_value = maxDiffuseTime
	diffuseBar.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print("Physics running...")
	prompt.text = ""
	
	if is_colliding():
		var collider = get_collider()
		
		if collider.name == "Bomb":
			prompt.text = "Diffuse " + collider.name
		else:
			prompt.text = "This is a wall called: " + collider.name
		
		if collider is Interactable: 
			prompt.text = collider.prompt_message
			
			if Input.is_action_pressed("interact") and is_colliding():
				collider.interact(owner)
				prompt.text = "Diffusing" 
				currentDiffuseTime += 8 * delta
				clamp(currentDiffuseTime, 0 , maxDiffuseTime)
				diffuseBar.value = currentDiffuseTime
				diffuseBar.visible = true
			else: 
				currentDiffuseTime = 0
				diffuseBar.value = currentDiffuseTime
				diffuseBar.visible = false
	
	

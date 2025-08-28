extends CollisionObject3D
class_name Interactable

@export var prompt_message = "Diffuse with [F]"

func interact(body):
	print(body.name, " is diffusing the ", name)

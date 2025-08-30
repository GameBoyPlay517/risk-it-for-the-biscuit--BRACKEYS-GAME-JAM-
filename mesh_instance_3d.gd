extends Node3D

@onready var player = $Player


func _physics_process(_delta):
	get_tree().call_group("enemies", "update_target_position", player.global_transform.origin)


func _on_player_hit() -> void:
	pass
	 # Replace with function body.

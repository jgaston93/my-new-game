extends Camera2D

@export var target: Node2D # Assign the player node in the inspector

func _physics_process(_delta: float):
	if target:
		global_position = target.global_position

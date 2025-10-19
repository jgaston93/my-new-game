extends Node

@onready var interactable: Area2D = $Interactable

@export var scene_name: String

func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
	SceneManager.change_scene(scene_name)

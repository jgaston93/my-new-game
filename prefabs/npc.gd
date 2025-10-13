extends CharacterBody2D

@onready var interactable: Area2D = $Interactable

@export var dialogue: Resource
@export var sprite_region: Rect2

func _ready() -> void:
	interactable.interact = _on_interact
	$Sprite2D.texture.region = sprite_region
	
func _on_interact():
	var _dialogue_line = DialogueManager.show_dialogue_balloon(dialogue)

extends Node

@onready var interactable: Area2D = $Interactable

func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
	var _dialogue_line = DialogueManager.show_dialogue_balloon(load("res://dialogue/npc_dialogue.dialogue"))

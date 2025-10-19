extends Node

var scene_container: Node
var player: CharacterBody2D
var current_map_name: String

var door_mapping: Dictionary = {"library": "LibraryDoorMarker", 
								"overworld": "LibraryDoorMarker"}


func change_scene(map_name: String) -> void:
	if scene_container.has_node("CurrentScene"):
		scene_container.get_node("CurrentScene").free()
	else:
		current_map_name = "overworld"
	var new_scene_resource : Resource = load("res://maps/" + map_name + ".tscn")
	var new_scene_instance = new_scene_resource.instantiate()
	new_scene_instance.name = "CurrentScene"
	scene_container.add_child(new_scene_instance)
	player.start(scene_container.get_node("CurrentScene/" + door_mapping[current_map_name]).position)
	current_map_name = map_name
	
func set_scene_container(container: Node) -> void:
	scene_container = container
	
func set_player(p: CharacterBody2D) -> void:
	player = p

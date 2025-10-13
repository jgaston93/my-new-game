extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_scene_resource : Resource = load("res://maps/overworld.tscn")
	var new_scene_instance = new_scene_resource.instantiate()
	new_scene_instance.name = "CurrentScene"
	$SceneContainer.add_child(new_scene_instance)
	$StartScreenMarker/AspectRatioContainer/StartSceenUI.connect("start_new_game", new_game)

func new_game():
	$StartScreenMarker/AspectRatioContainer.hide()
	$Player.start(get_node("SceneContainer/CurrentScene/StartPosition").position)
	$Camera2D2.target = $Player

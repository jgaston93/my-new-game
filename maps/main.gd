extends Node

func _ready() -> void:
	SceneManager.set_scene_container($SceneContainer)
	SceneManager.set_player($Player)
	SceneManager.change_scene("overworld")
	$StartScreenMarker/AspectRatioContainer/StartSceenUI.connect("start_new_game", new_game)

func new_game():
	$StartScreenMarker/AspectRatioContainer.hide()
	$Player.start(get_node("SceneContainer/CurrentScene/StartPosition").position)
	$Camera2D2.target = $Player

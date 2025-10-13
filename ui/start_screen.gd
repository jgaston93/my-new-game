extends Control

signal start_new_game()

func _on_button_pressed() -> void:
	emit_signal("start_new_game")

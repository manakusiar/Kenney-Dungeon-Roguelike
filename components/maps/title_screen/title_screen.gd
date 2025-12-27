extends Node2D


func _on_start_game_pressed() -> void:
	SceneManager.change_scene("main_room")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()

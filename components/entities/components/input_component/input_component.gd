class_name InputComponent
extends Node

# The normalized movement direction (read by other components)
var movement_direction: Vector2 = Vector2.ZERO

# Optional: expose aim direction for shooting
var aim_direction: Vector2 = Vector2.RIGHT

@export var use_mouse_aim: bool = true


func _process(_delta: float) -> void:
	_update_movement_input()
	_update_aim_input()


func _update_movement_input() -> void:
	# Read raw input
	var raw_input := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	# Normalize to prevent faster diagonal movement
	# Using limit_length instead of normalized to allow analog stick partial input
	movement_direction = raw_input.limit_length(1.0)


func _update_aim_input() -> void:
	if use_mouse_aim:
		var player := get_parent() as Node2D
		if player:
			aim_direction = (player.get_global_mouse_position() - player.global_position).normalized()

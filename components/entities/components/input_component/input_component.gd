class_name InputComponent
extends Node

signal jump

var movements = {
	"left": false,
	"right": false,
	"up": false,
	"down": false
}

func _input(event: InputEvent) -> void:
	for key in movements.keys():
		var value = movements[key]
		if value == false and event.is_action_pressed("move_" + key):
			movements[key] = true
		elif value == true and event.is_action_released("move_" + key):
			movements[key] = false

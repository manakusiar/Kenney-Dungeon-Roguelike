class_name MovementComponent
extends Node

@onready var player: Player = get_owner()
@onready var input_component: InputComponent = player.input_component

func manage_movement(delta):
	var move_input = input_component.movements
	move_input = Vector2(
		int(move_input["right"]) - int(move_input["left"]),
		int(move_input["down"]) - int(move_input["up"]))
	
	player.velocity += move_input
	player.position += player.velocity
	player.velocity *= 0.9

class_name Player
extends CharacterBody2D

@export_group("Nodes")
@export var animated_sprite: AnimatedSprite2D
@export_subgroup("Components")
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var input_component: InputComponent

func _process(delta: float) -> void:
	movement_component.manage_movement(delta)

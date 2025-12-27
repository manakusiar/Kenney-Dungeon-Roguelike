class_name MovementComponent
extends Node

# Reference to the input source
@export var input_component: InputComponent

# The body we're moving
@export var body: CharacterBody2D

# --- Movement Tuning (Nuclear Throne-style values) ---
@export_group("Movement Stats")
@export var max_speed: float = 220.0           # Pixels per second
@export var acceleration: float = 2000.0       # High = snappy response
@export var friction: float = 2400.0           # High = quick stops
@export var air_friction_multiplier: float = 0.5  # Optional: for knockback situations

# Current velocity (exposed for other systems like knockback)
var velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	# Auto-find components if not assigned
	if not input_component:
		input_component = get_parent().get_node_or_null("InputComponent")
	if not body:
		body = get_parent() as CharacterBody2D


func _physics_process(delta: float) -> void:
	var input_dir := _get_input_direction()
	
	if input_dir != Vector2.ZERO:
		_apply_acceleration(input_dir, delta)
	else:
		_apply_friction(delta)
	
	_move(delta)


func _get_input_direction() -> Vector2:
	if input_component:
		return input_component.movement_direction
	return Vector2.ZERO


func _apply_acceleration(direction: Vector2, delta: float) -> void:
	# Target velocity based on input
	var target_velocity := direction * max_speed
	
	# Move toward target velocity
	# This approach allows direction changes to feel snappy
	velocity = velocity.move_toward(target_velocity, acceleration * delta)


func _apply_friction(delta: float) -> void:
	# Decelerate to zero when no input
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func _move(_delta: float) -> void:
	body.velocity = velocity
	body.move_and_slide()
	
	# Sync back (in case of collisions)
	velocity = body.velocity


# --- Public API for other systems ---

func apply_knockback(force: Vector2) -> void:
	velocity += force


func set_velocity(new_velocity: Vector2) -> void:
	velocity = new_velocity

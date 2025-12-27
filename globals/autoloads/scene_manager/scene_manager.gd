extends CanvasLayer

@export_subgroup("Nodes")
@export var player: AnimationPlayer
@export var rect: ColorRect

signal transition_started
signal scene_changed
signal transition_finished

var scene_paths = {
	"title_screen": "res://components/maps/title_screen/title_screen.tscn",
	"main_room": "res://components/maps/main_room/main_room.tscn"
}

var next_scene = "title_screen"
var is_transitioning = false

func change_scene(scene_name: String, transition_type: String = "grid", duration: float = 4) -> void:
	if is_transitioning:
		return
	
	is_transitioning = true
	rect.mouse_filter = Control.MOUSE_FILTER_STOP
	transition_started.emit()
	
	await _transition_in(transition_type, duration)
	
	get_tree().change_scene_to_file(scene_paths[scene_name])
	scene_changed.emit()
	
	await get_tree().process_frame
	
	await _transition_out(transition_type, duration)
	
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	is_transitioning = false
	emit_signal("transition_finished")

func _transition_in(type: String, duration: float = 1.0) -> void:
	match type:
		"fade":
			player.speed_scale = duration
			player.play("fade_in")
			await player.animation_finished
		"grid":
			player.speed_scale = duration
			player.play("grid_in")
			await player.animation_finished
		"instant":
			rect.color = Color(0, 0, 0, 0)
		_:
			player.speed_scale = duration
			player.play("fade_in")
			await player.animation_finished


func _transition_out(type: String, duration: float = 1.0) -> void:
	match type:
		"fade":
			player.speed_scale = duration
			player.play("fade_out")
			await player.animation_finished
		"grid":
			player.speed_scale = duration
			player.play("grid_out")
			await player.animation_finished
		"instant":
			rect.color = Color(0, 0, 0, 0)
		_:
			player.speed_scale = duration
			player.play("fade_out")
			await player.animation_finished

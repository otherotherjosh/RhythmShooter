extends Node2D


enum State {
	IDLE,
	AIMING,
	FIRING,
}

const SHOOT_TIMEOUT := 0.05

var state: State
var aim_position: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var camera_2d: Camera2D = $"../Camera2D"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_event_mouse_motion(event)
	if event.is_action_pressed("shoot"):
		shoot()


func _draw() -> void:
	if state != State.IDLE:
		var line_color := Color.RED if state == State.FIRING else Color.GREEN
		draw_line(marker_2d.position, aim_position, line_color)


func aim_at(target: Vector2) -> void:
	if state == State.FIRING:
		return
	state = State.AIMING
	aim_position = to_local(target)
	queue_redraw()


func shoot() -> void:
	if state == State.FIRING: 
		return
	state = State.FIRING
	queue_redraw()
	await get_tree().create_timer(SHOOT_TIMEOUT).timeout
	state = State.AIMING


func handle_event_mouse_motion(event: InputEventMouseMotion) -> void:
	var event_world_pos := get_viewport().canvas_transform.affine_inverse() * event.position
	aim_at(event_world_pos)
	print("aiming at %s from %s" % [event.position, global_position])

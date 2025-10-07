extends Node2D


enum State {
	IDLE,
	AIMING,
	FIRING,
}

var state: State
var fire_direction: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var camera_2d: Camera2D = $"../Camera2D"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_event_mouse_motion(event)
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_released("shoot"):
		stop_shooting()


func _draw() -> void:
	if state != State.IDLE:
		var line_color := (Color.GREEN if state == State.AIMING else
				Color.RED if state == State.FIRING else Color.AQUA)


func aim_at(target: Vector2) -> void:
	if state != State.FIRING:
		state = State.AIMING
	var aim_position := to_local(target)
	fire_direction = marker_2d.position.direction_to(aim_position)
	queue_redraw()
	look_at(target)


func shoot() -> void:
	if state == State.FIRING:
		return
	state = State.FIRING
	queue_redraw()


func stop_shooting() -> void:
	state = State.IDLE
	queue_redraw()


func handle_event_mouse_motion(event: InputEventMouseMotion) -> void:
	var event_world_pos := get_viewport().canvas_transform.affine_inverse() * event.position
	aim_at(event_world_pos)

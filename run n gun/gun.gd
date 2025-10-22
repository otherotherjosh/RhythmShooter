extends Node2D


enum State {
	IDLE,
	AIMING,
	FIRING,
}

var state: State
var fire_direction: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var laser_beam: GunLaserBeam = $LaserBeam


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_event_mouse_motion(event)
	if event.is_action_pressed("shoot"):
		start_shooting()
	if event.is_action_released("shoot"):
		end_shooting()


func _draw() -> void:
	if state != State.IDLE:
		var line_color := (Color.GREEN if state == State.AIMING else
				Color.RED if state == State.FIRING else Color.AQUA)


func aim_at(target: Vector2) -> void:
	if state != State.FIRING:
		state = State.AIMING
	var aim_position := to_local(target)
	fire_direction = laser_beam.position.direction_to(aim_position)
	look_at(target)


func start_shooting() -> void:
	if state == State.FIRING:
		return
	state = State.FIRING
	laser_beam.start_shooting()


func end_shooting() -> void:
	state = State.IDLE
	laser_beam.end_shooting()


func handle_event_mouse_motion(event: InputEventMouseMotion) -> void:
	var event_world_pos := get_viewport().canvas_transform.affine_inverse() * event.position
	aim_at(event_world_pos)

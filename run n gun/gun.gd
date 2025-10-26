class_name Gun extends Node2D


signal fire_direction_changed

enum State {
	IDLE,
	AIMING,
	FIRING,
}

var state: State:
	set = _set_state
var fire_direction: Vector2:
	set = _set_fire_direction
var tween: Tween

@onready var touch_input_manager: TouchInputManager = %TouchInputManager
@onready var combat_manager: CombatManager = %CombatManager
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var laser_beam: GunLaserBeam = $LaserBeam
@onready var idle_timer: Timer = $IdleTimer


func _ready() -> void:
	touch_input_manager.screen_touch_pressed.connect(handle_screen_touch_pressed)
	touch_input_manager.screen_touch_released.connect(handle_screen_touch_released)
	reset_tween()


func _process(_delta: float) -> void:
	if state == State.FIRING and combat_manager.enemy_aimed_at:
		aim_at(combat_manager.enemy_aimed_at.global_position)


func aim_at(target: Vector2) -> void:
	if state != State.FIRING:
		state = State.AIMING
	reset_tween()
	fire_direction = global_position.direction_to(target)
	look_at(target)
	if scale.x == -1:
		rotate(PI)


func start_shooting() -> void:
	if state == State.FIRING:
		return
	state = State.FIRING
	laser_beam.start_shooting()
	combat_manager.player_start_shooting()
	if not idle_timer.is_stopped():
		idle_timer.stop()


func stop_shooting() -> void:
	state = State.AIMING
	laser_beam.stop_shooting()
	combat_manager.player_stop_shooting()
	idle_timer.start()


func reset_tween() -> void:
	if tween:
		if tween.is_running():
			tween.stop()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)


func handle_screen_touch_pressed(touch_position: Vector2) -> void:
	if state == State.FIRING:
		return
	var world_pos := get_viewport().canvas_transform.affine_inverse() * touch_position
	aim_at(world_pos)
	start_shooting()


func handle_screen_touch_released() -> void:
	if state == State.FIRING:
		stop_shooting()


func _on_idle_timer_timeout() -> void:
	reset_tween()
	state = State.IDLE
	if rotation > PI:
		# prefer negative rotation rather than 180+ degrees
		rotation -= PI * 2
	tween.tween_property(self, "rotation", 0, 1)


func _set_fire_direction(value: Vector2) -> void:
	fire_direction = value
	fire_direction_changed.emit()


func _set_state(value: State) -> void:
	if value == State.IDLE and state == State.FIRING:
		return # cannot idle when firing
	state = value

class_name Player extends CharacterBody2D
## Body with 2D platformer controls. Can run and jump. Has a gun.
## Founded on default character body script


const SPEED := 150.0
const JUMP_VELOCITY := -300.0
const JUMP_COYOTE_TIME_MSEC := 150

## which way the player is facing (-1 left, +1 right)
var look_direction: int = 1:
	set = _set_look_direction

var jump_state: JumpState = JumpState.new()

@onready var touch_input_manager: TouchInputManager = %TouchInputManager
@onready var combat_manager: CombatManager = %CombatManager
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gun: Gun = $Gun


func _ready() -> void:
	combat_manager.player = self
	touch_input_manager.jump_button_pressed.connect(jump_state.handle_jump_button_pressed)


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	process_jump()
	process_movement_and_direction()
	move_and_slide()


## Checks for jump state and jumps when the circumstances are correct
func process_jump() -> void:
	if (is_on_floor()
			and not jump_state.has_jumped 
			and jump_state.time_since_pressed_msec < JUMP_COYOTE_TIME_MSEC):
		velocity.y = JUMP_VELOCITY
		jump_state.has_jumped = true


## Handles movement and flips sprite when direction changes
func process_movement_and_direction() -> void:
	var direction := touch_input_manager.joystick_x_axis
	if direction:
		velocity.x = direction * SPEED
		if not combat_manager.player_is_shooting:
			look_direction = -1 if direction < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _set_look_direction(value: int) -> void:
	if look_direction == value:
		return
	look_direction = value
	sprite_2d.scale.x = look_direction
	gun.scale.x = look_direction
	gun.position.x = abs(gun.position.x) * look_direction
	if gun.state != Gun.State.FIRING:
		gun.rotation = 0


func _on_gun_fire_direction_changed() -> void:
	look_direction = -1 if gun.fire_direction.x < 0 else 1


class JumpState:
	
	var time_pressed_msec: int
	var time_since_pressed_msec: int:
		get = _get_time_since_pressed_msec
	var has_jumped: bool
	
	
	func handle_jump_button_pressed() -> void:
		time_pressed_msec = Time.get_ticks_msec()
		has_jumped = false
	
	
	func _get_time_since_pressed_msec() -> int:
		return Time.get_ticks_msec() - time_pressed_msec

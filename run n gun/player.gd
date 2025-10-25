extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0

## which way the player is facing (-1 left, +1 right)
var look_direction: int = 1:
	set = _set_look_direction

@onready var touch_input_manager: TouchInputManager = %TouchInputManager
@onready var combat_manager: CombatManager = %CombatManager
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gun: Gun = $Gun


func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := touch_input_manager.joystick_x_axis
	if direction:
		velocity.x = direction * SPEED
		if not combat_manager.player_is_shooting:
			look_direction = -1 if direction < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


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

extends Control
## Virtual joystick controlled via touchscreen


var center: Vector2:
	get = _get_center
var stick_position: Vector2:
	set = _set_stick_position

@onready var stick: TextureRect = $Stick
@onready var border: TextureRect = $Border
@onready var touch_input_manager: TouchInputManager = %TouchInputManager


func _process(_delta: float) -> void:
	touch_input_manager.joystick_x_axis = stick_position.x / (border.size.x / 2)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		move_stick(event.position)
	if event is InputEventScreenTouch:
		if event.is_pressed():
			move_stick(event.position)
		if event.is_released():
			reset_stick()


func move_stick(event_position: Vector2) -> void:
	stick_position = event_position - center


func reset_stick() -> void:
	stick_position = Vector2.ZERO


func _get_center() -> Vector2:
	return size / 2


func _set_stick_position(value: Vector2) -> void:
	stick_position = value
	if stick_position.length() > border.size.x / 2:
		stick_position = stick_position.normalized() * border.size.x / 2
	stick.position = center + stick_position - stick.size / 2

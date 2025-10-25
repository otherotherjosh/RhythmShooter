class_name TouchInputManager extends Node


var joystick_x_axis: float:
	set = _set_joystick_x_axis

signal screen_touch_pressed(touch_position: Vector2)
signal screen_touch_released


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			screen_touch_pressed.emit(event.position)
		if event.is_released():
			screen_touch_released.emit()


func _set_joystick_x_axis(value: float) -> void:
	joystick_x_axis = clampf(value, -1, 1)

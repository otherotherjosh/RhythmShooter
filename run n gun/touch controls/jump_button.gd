extends Control
## Vitual button controlled via touchscreen


@onready var touch_input_manager: TouchInputManager = %TouchInputManager


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		touch_input_manager.jump_button_pressed.emit()

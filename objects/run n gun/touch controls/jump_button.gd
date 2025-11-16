extends Control
## Vitual button controlled via touchscreen


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		TouchInputManager.jump_button_pressed.emit()

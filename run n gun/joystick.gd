extends Control


var center: Vector2:
	get = _get_center
var stick_position: Vector2:
	set = _set_stick_position
var move_event: InputEventAction
var move_event_action: String:
	set = _set_move_event_action

@onready var stick: TextureRect = $Stick
@onready var border: TextureRect = $Border


func _ready() -> void:
	move_event = InputEventAction.new()


func _process(delta: float) -> void:
	if stick_position:
		call_move_event()


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
	release_move_event()


func call_move_event() -> void:
	move_event_action = "move_left" if stick_position.x < 0 else "move_right"
	move_event.strength = absf(stick_position.x / (center.x))
	move_event.pressed = true
	Input.parse_input_event(move_event)


func release_move_event() -> void:
	if move_event_action:
		move_event.pressed = false
		Input.parse_input_event(move_event)


func _get_center() -> Vector2:
	return size / 2


func _set_stick_position(value: Vector2) -> void:
	stick_position = value
	if stick_position.length() > border.size.x / 2:
		stick_position = stick_position.normalized() * border.size.x / 2
	stick.position = center + stick_position - stick.size / 2


func _set_move_event_action(value: String) -> void:
	if move_event_action == value:
		return
	release_move_event()
	move_event_action = value
	move_event.action = move_event_action

class_name DialogueBox extends NinePatchRect


enum State {
	IDLE,
	TYPING,
	TYPED,
}

var state: State
var dialogue_script: DialogueScript
var line: int
var skip_pressed: bool

@onready var text: RichTextLabel = $HBoxContainer/Text


func _ready() -> void:
	TouchInputManager.screen_touch_pressed.connect(_on_screen_touch_pressed)


func play_dialogue() -> void:
	if not dialogue_script:
		state = State.IDLE
		return
	line = 0
	while line < dialogue_script.lines.size():
		await play_dialogue_line()
		line += 1


func play_dialogue_line() -> void:
	state = State.TYPING
	text.text = dialogue_script.lines[line].text
	text.visible_ratio = 0
	# run text
	while text.visible_ratio < 1:
		text.visible_ratio += get_process_delta_time()
		if skip_pressed:
			skip_pressed = false
			text.visible_ratio = 1
		await get_tree().process_frame
	# await input
	while not skip_pressed:
		await get_tree().process_frame
	skip_pressed = false


func _on_screen_touch_pressed(_position) -> void:
	skip_pressed = true

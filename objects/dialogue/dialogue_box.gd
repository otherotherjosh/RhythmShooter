class_name DialogueBox extends NinePatchRect


const TYPE_SPEED = 50

var dialogue_script: DialogueScript
var line: int
var skip_pressed: bool

@onready var sprite: TextureRect = $HBoxContainer/Sprite
@onready var text: RichTextLabel = $HBoxContainer/Text


func _ready() -> void:
	TouchInputManager.screen_touch_pressed.connect(_on_screen_touch_pressed)
	visible = false


func play_dialogue() -> void:
	if not dialogue_script:
		return
	visible = true
	line = 0
	while line < dialogue_script.lines.size():
		await play_dialogue_line(dialogue_script.lines[line])
		line += 1
	visible = false


func play_dialogue_line(line: Dialogue) -> void:
	sprite.texture = line.character_sprite
	text.text = line.text
	text.visible_ratio = 0
	# run text
	while text.visible_ratio < 1:
		text.visible_ratio += get_process_delta_time() * TYPE_SPEED / text.text.length()
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

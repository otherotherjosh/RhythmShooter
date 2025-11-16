extends Node2D


@export var labels: Array[RichTextLabel]

var skip_taps := 0

@onready var skip_hint: RichTextLabel = $CanvasLayer/SkipHint


func _ready() -> void:
	TouchInputManager.screen_touch_pressed.connect(skip_tap)
	skip_hint.visible = false
	for label in labels:
		label.visible = false
	await get_tree().create_timer(1).timeout
	for label in labels:
		label.visible = true
		await get_tree().create_timer(2).timeout
	Global.load_level(0)


func skip_tap(_pos) -> void:
	skip_taps += 1
	match skip_taps:
		2:
			skip_hint.visible = true
		3:
			Global.load_level(0)

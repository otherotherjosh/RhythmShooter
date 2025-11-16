extends Node2D


@export var labels: Array[RichTextLabel]


func _ready() -> void:
	for label in labels:
		label.visible = false
	await get_tree().create_timer(1).timeout
	for label in labels:
		label.visible = true
		await get_tree().create_timer(2).timeout
	Global.load_level(0)

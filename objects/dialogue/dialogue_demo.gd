extends Node2D


@export var dialogue_script: DialogueScript

@onready var dialogue_box: DialogueBox = $CanvasLayer/DialogueBox


func _ready() -> void:
	# TEST
	dialogue_box.dialogue_script = dialogue_script
	dialogue_box.play_dialogue()

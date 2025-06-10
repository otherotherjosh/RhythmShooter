class_name SmashNotePlayer extends Node
## Handles player input to smash notes on screen.

## locates the axis crossing where notes should be smashed
@onready var aim_bar: Sprite2D = $AimBar
## spawner and mover of notes
@onready var note_factory: SmashNoteFactory = $NoteFactory


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	for i in range(4):
		var action := "smash_%s" % (i + 1)
		if event.is_action_pressed(action):
			print(action)

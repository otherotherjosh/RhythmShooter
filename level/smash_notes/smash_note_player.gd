class_name SmashNotePlayer extends Node
## Handles player input to smash notes on screen.


## Locates the axis crossing where notes should be smashed
@onready var aim_bar: Sprite2D = $AimBar
## Spawner and mover of notes
@onready var note_factory: SmashNoteFactory = $NoteFactory


func _ready() -> void:
	note_factory.aim_bar_position = aim_bar.global_position


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	for i in range(4):
		var action := "smash_%s" % i
		if event.is_action_pressed(action):
			smash_note(i)


## Attempts to smash a note from a channel
func smash_note(channel: int) -> void:
	pass

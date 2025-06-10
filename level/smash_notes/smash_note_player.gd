class_name SmashNotePlayer extends Node
## Handles player input to smash notes on screen.


## Reports the smash score from a note getting smashed
signal note_smashed(score: int)

## Distance (pixels) from aim bar where notes are smashable
@export var smash_distance := 75

## Locates the axis crossing where notes should be smashed
@onready var aim_bar: Sprite2D = $AimBar
## Spawner and mover of notes
@onready var note_factory: SmashNoteFactory = $NoteFactory


func _ready() -> void:
	note_factory.aim_bar_position = aim_bar.global_position
	note_factory.miss_distance = smash_distance


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	for i in range(4):
		var action := "smash_%s" % i
		if event.is_action_pressed(action):
			smash_note(i)


## Attempts to smash a note from a channel
func smash_note(channel: int) -> void:
	# do nothing if channel is empty
	if !note_factory.note_channels[channel].size(): return
	
	var note := note_factory.note_channels[channel][0] as Sprite2D
	# cry if note is too far away
	if note.global_position.y < aim_bar.global_position.y - smash_distance:
		print("way too soon!! -1 aura point!!")
		return
	# successfully smash that note
	var score := calculate_score(note)
	note_smashed.emit(score)
	print("score: %s" % score)
	note_factory.destroy_note(channel)


func calculate_score(note: Sprite2D) -> int:
	var distance: int = abs(note.global_position.y - aim_bar.global_position.y)
	print("distance: %s" % distance)
	return inverse_lerp(smash_distance, 0, distance) * 100 as int

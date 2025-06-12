class_name SmashNotePlayer extends Node
## Handles player input to smash notes on screen.


## Reports the smash score from a note getting smashed
signal note_smashed(score: int)

## Distance (pixels) from aim bar where notes are smashable
@export var smash_distance := 75
## Feedback text labels for note channels
@export var feedback_labels: Array[Label]
## How long feedback text should stick around for
@export var feedback_timeout_sec := 0.9

## Timers to hide feedback labels
var feedback_end_timers: Array[Timer]

## Locates the axis crossing where notes should be smashed
@onready var aim_bar: Sprite2D = $AimBar
## Spawner and mover of notes
@onready var note_factory: SmashNoteFactory = $NoteFactory


func _ready() -> void:
	note_factory.aim_bar_position = aim_bar.global_position
	note_factory.miss_distance = smash_distance
	init_feedback_end_timers()


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	for i in range(4):
		var action := "smash_%s" % i
		if event.is_action_pressed(action):
			smash_note(i)


func init_feedback_end_timers() -> void:
	for i in range(feedback_labels.size()):
		var timer := Timer.new()
		timer.wait_time = feedback_timeout_sec
		feedback_end_timers.append(timer)
		feedback_labels[i].add_child(timer)
		
		var hide_label = func ():
			feedback_labels[i].visible = false
		timer.timeout.connect(hide_label)


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
	show_feedback(channel, score)
	note_factory.destroy_note(channel)


## Returns a score from 0 to 100 based on how close a note is to the aim bar
func calculate_score(note: Sprite2D) -> int:
	var distance: int = abs(note.global_position.y - aim_bar.global_position.y)
	print("distance: %s" % distance)
	return inverse_lerp(smash_distance, 0, distance) * 100 as int


## Displays text to show player how they performed on a note smash
func show_feedback(channel: int, score: int) -> void:
	var feedback: String = (
			"Perfect" if score >= 95  else
			"Great" if score >= 80 else
			"Good" if score >= 50 else
			"Okay")
	feedback_labels[channel].text = feedback
	feedback_labels[channel].visible = true
	feedback_end_timers[channel].start()


func _on_note_factory_note_missed(channel: int) -> void:
	feedback_labels[channel].text = "Miss"
	feedback_labels[channel].visible = true
	feedback_end_timers[channel].start()

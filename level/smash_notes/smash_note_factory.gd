class_name SmashNoteFactory extends Node
## Spawns and moves smash notes in sync with music 

## Called when a note 
signal note_missed(channel: int)

const NOTE_PREFAB = preload("res://level/smash_notes/smash_note.tscn")

## Speed the notes move in pixels per second
@export var note_speed := 100
## Note spawning positions
@export var spawnpoints: Array[Marker2D]
## How far (in pixels) from the aim bar notes should be considered missed
@export var miss_distance := 100

## 2D array of notes
var note_channels: Array[Array]
## Global position of the aim bar
var aim_bar_position: Vector2


func _ready() -> void:
	init_channels()
	spawn_random_note_loop()


func _process(delta: float) -> void:
	# moves all notes equally, no syncing with time base of music yet
	for i in range(4):
		for note in note_channels[i]:
			note = note as Sprite2D
			note.global_position.y += note_speed * delta
			# miss notes
			if note.global_position.y > aim_bar_position.y + miss_distance:
				note_channels[i].pop_front()
				note.queue_free()
				note_missed.emit(i)


## Initializes note_channels 2D array
func init_channels() -> void:
	for spawnpoint in spawnpoints:
		var note_array: Array[Sprite2D] = []
		note_channels.append(note_array)
		

## Testing function to spawn random notes
func spawn_random_note_loop() -> void:
	while true:
		await get_tree().create_timer(0.7).timeout
		var channel := randi_range(0, note_channels.size() - 1)
		spawn_note(channel)
		

## Spawns a note at a specific spawnpoint
func spawn_note(channel: int) -> void:
	var note: Sprite2D = NOTE_PREFAB.instantiate()
	note.global_position = spawnpoints[channel].global_position
	note_channels[channel].append(note)
	add_child(note)

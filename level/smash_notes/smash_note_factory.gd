class_name SmashNoteFactory extends Node
## Spawns and moves smash notes in sync with music 


## Called when a note is missed
signal note_missed(channel: int)

const NOTE_PREFAB = preload("res://level/smash_notes/smash_note.tscn")

## How much time notes spend between appearing and smashing
@export var note_appear_duration_ms: int
## Note spawning positions
@export var spawnpoints: Array[Marker2D]

## 2D array of notes
var note_channels: Array[Array]
## Global position of the aim bar
var aim_bar_position: Vector2
## After how long to consider a note missed
var miss_time_ms: int

@onready var midi_player: MidiPlayer = $MidiPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	init_channels()
	# wait a moment for midi player to be ready
	await get_tree().create_timer(0.5).timeout
	midi_player.play()
	await get_tree().create_timer(note_appear_duration_ms / 1000.0).timeout
	audio_stream_player.play()


func _process(delta: float) -> void:
	# moves all notes into position based on time
	var ticks_msec = Time.get_ticks_msec()
	for i in range(4):
		for note in note_channels[i]:
			note = note as SmashNote
# position note based on current time vs its target time
			var pos_value = inverse_lerp(
					note.target_time_ms - note_appear_duration_ms, note.target_time_ms, ticks_msec)
			note.global_position.y = lerpf(
					spawnpoints[i].global_position.y, aim_bar_position.y, pos_value)
			#note.global_position.y -= 100 * delta
			# miss notes
			if note.target_time_ms < ticks_msec - miss_time_ms:
				destroy_note(i)
				note_missed.emit(i)


## Initializes note_channels 2D array
func init_channels() -> void:
	for spawnpoint in spawnpoints:
		var note_array: Array[SmashNote] = []
		note_channels.append(note_array)
		

## Testing function to spawn random notes
func spawn_random_note_loop() -> void:
	while true:
		await get_tree().create_timer(0.25).timeout
		var channel := randi_range(0, note_channels.size() - 1)
		spawn_note(channel)
		

## Spawns a note at a specific spawnpoint
func spawn_note(channel: int) -> void:
	var note := NOTE_PREFAB.instantiate() as SmashNote
	note.global_position = spawnpoints[channel].global_position
	note.target_time_ms = Time.get_ticks_msec() + note_appear_duration_ms
	note_channels[channel].append(note)
	print(note_channels[channel])
	add_child(note)


## Despawns the front note in the channel
func destroy_note(channel: int) -> void:
	var note := note_channels[channel].pop_front() as SmashNote
	note.queue_free()


func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	if event is SMF.MIDIEventNoteOn:
		var smash_channel := randi_range(0, note_channels.size() - 1)
		spawn_note(smash_channel)

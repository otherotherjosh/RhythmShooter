extends Node
## Plays through beatmaps, globally accessible


signal on_queue
signal on_play
signal on_beat
signal on_target

## How long a BeatTarget is active and can be hit
const TARGET_ACTIVE_WINDOW := 0.3

var beatmap: Beatmap:
	set = _set_beatmap
var bpm := 120.0:
	set = _set_bpm
var pulse_ms := 500
var current_beat: float:
	set = _set_current_beat
var is_playing: bool
## Targets from the active beatmap
var beat_targets: Array[BeatTarget]
## Index of last active target
var current_target: int


func _process(delta: float) -> void:
	if not is_playing:
		return
	current_beat = MusicPlayer.seek / MusicPlayer.pulse
	
	if current_target >= beat_targets.size(): return
	var target := beat_targets[current_target]
	if current_beat >= target.beat + target.measure:
		current_target += 1
		on_target.emit()


## Begins playing through the active beatmap
func play_beatmap() -> void:
	current_beat = 0
	current_target = 0
	is_playing = true
	on_play.emit()


## Get beatmap ready to play
func queue_beatmap() -> void:
	on_queue.emit()
	MusicPlayer.queue_game_track(4)
	await MusicPlayer.on_play
	play_beatmap()


## Calculates when (in seconds from when the track started) the beat and measure of a target will occur
func time_of_target(index: int) -> float:
	var beat := beat_targets[index].beat
	var measure := beat_targets[index].measure
	return (beat + measure) * MusicPlayer.pulse


## Calculates how much time (in seconds) until the beat and measure of a target occurs
func time_to_target(index: int) -> float:
	return time_of_target(index) - MusicPlayer.seek


func _set_beatmap(value: Beatmap) -> void:
	if beatmap == value:
		return
	beatmap = value
	is_playing = false
	MusicPlayer.game_track = beatmap.track
	# 120 is arbitrary, what matters is it's not 0
	bpm = beatmap.track.bpm if beatmap.track.bpm else 120
	beatmap.sort_targets()
	beat_targets = beatmap.targets 


func _set_bpm(value: float) -> void:
	bpm = value
	pulse_ms = 60000 / bpm


func _set_current_beat(value: float) -> void:
	if floor(current_beat) < floor(value):
		on_beat.emit()
	current_beat = value

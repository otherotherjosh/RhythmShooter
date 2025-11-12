extends Node
## Plays through beatmaps, globally accessible


signal on_queue
signal on_play

## How long a BeatTarget is active and can be hit
const TARGET_ACTIVE_WINDOW := 0.3

var beatmap: Beatmap:
	set = _set_beatmap
var bpm := 120.0:
	set = _set_bpm
var pulse_ms := 500
var seek: float
var current_beat: int:
	get: return floori(seek)
var current_measure: float:
	get: return seek - current_beat
var is_playing: bool
## Targets from the active beatmap
var beat_targets: Array[BeatTarget]
# Index of target that is either first ready or last active
var current_target: int


func _process(delta: float) -> void:
	if not is_playing:
		return
	seek = MusicPlayer.seek / MusicPlayer.pulse


## Begins playing through the active beatmap
func play_beatmap() -> void:
	current_beat = 0
	current_measure = 0
	current_target = 0
	is_playing = true
	on_play.emit()


## Get beatmap ready to play
func queue_beatmap() -> void:
	on_queue.emit()
	MusicPlayer.queue_game_track(4)
	await MusicPlayer.on_play
	play_beatmap()


## Calculates when (in ms) the beat and measure of a target will occur
func time_of_target(index: int) -> int:
	var beat := beat_targets[index].beat
	var measure := beat_targets[index].measure
	return MusicPlayer.track_begin_time_ms + (beat + measure) * pulse_ms


## Calculates how much time (in ms) until the beat and measure of a target occurs
func time_to_target(index: int) -> int:
	return time_of_target(index) - Time.get_ticks_msec()


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

extends Node
## Plays through beatmaps, globally accessible


enum State {
	IDLE,
	QUEUED,
	PLAYING,
}

signal on_queue
signal on_beat
signal on_target

## How long a BeatTarget is active and can be hit
const TARGET_ACTIVE_WINDOW := 0.3

var beatmap: Beatmap:
	set = _set_beatmap
var bpm := 120.0
var current_beat: float:
	set = _set_current_beat
## Targets from the active beatmap
var targets: Array[BeatTarget]
## Index of current target
var current_target: int
## Index of first ready target
var ready_target: int
var state: State


func _process(_delta: float) -> void:
	if state == State.IDLE:
		return
	current_beat = MusicPlayer.seek / MusicPlayer.pulse
	calculate_current_target()
	calculate_target_states()


## Begins playing through the active beatmap
func play_beatmap() -> void:
	state = State.PLAYING
	current_beat = 0
	current_target = 0
	ready_target = 0
	await MusicPlayer.game_track_player.finished
	stop_beatmap()


## Get beatmap ready to play
func queue_beatmap() -> void:
	state = State.QUEUED
	on_queue.emit()
	MusicPlayer.queue_game_track(4)
	await MusicPlayer.on_play
	play_beatmap()


## End playback of beatmap
func stop_beatmap() -> void:
	beatmap.complete.emit()
	state = State.IDLE


## Determines which target is "current"
func calculate_current_target() -> void:
	if current_target >= targets.size(): return
	var target := targets[current_target]
	if current_beat >= target.beat + target.measure:
		current_target += 1
		on_target.emit()


## Determines the states of ready and recently missed targets
func calculate_target_states() -> void:
	if ready_target >= targets.size(): return
	# wait for ready_target to be ready
	if time_to_target(ready_target) > TARGET_ACTIVE_WINDOW / 2.0:
		return
	# miss target
	if time_to_target(ready_target) < -TARGET_ACTIVE_WINDOW / 2.0:
		targets[ready_target].state = BeatTarget.State.MISSED
		ready_target += 1
		return
	# target is ready!
	targets[ready_target].state = BeatTarget.State.READY


## Hits the ready target
func hit_target() -> void:
	targets[ready_target].state = BeatTarget.State.HIT
	ready_target += 1


## Hits the ready target if it is ready
func attempt_hit_target() -> bool:
	if state == State.IDLE or ready_target >= targets.size(): 
		return false
	var success := targets[ready_target].state == BeatTarget.State.READY
	if success: hit_target()
	return success


## Calculates when (in seconds from when the track started) 
## the beat and measure of a target will occur
func time_of_target(index: int) -> float:
	var beat := targets[index].beat
	var measure := targets[index].measure
	return (beat + measure) * MusicPlayer.pulse


## Calculates how much time (in seconds) until the beat and measure of a target occurs
func time_to_target(index: int) -> float:
	return time_of_target(index) - MusicPlayer.seek


func _set_beatmap(value: Beatmap) -> void:
	if beatmap == value:
		return
	beatmap = value
	state = State.IDLE
	MusicPlayer.game_track = beatmap.track
	# 120 is arbitrary, what matters is it's not 0
	bpm = beatmap.track.bpm if beatmap.track.bpm else 120.0
	beatmap.sort_targets()
	targets = beatmap.targets 


func _set_current_beat(value: float) -> void:
	if floor(current_beat) < floor(value):
		on_beat.emit()
	current_beat = value

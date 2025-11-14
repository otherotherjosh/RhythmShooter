extends Node
## Plays music, globally accessible


signal on_count_in(count: int)
signal on_play

var game_track: AudioStreamOggVorbis:
	set = _set_game_track
var game_track_player: AudioStreamPlayer
var seek: float:
	get = _get_seek
var pulse: float
## Time since engine started when track will begin playing
var track_begin_time: float
var output_latency: float
var queued: bool


func _ready() -> void:
	game_track_player = AudioStreamPlayer.new()
	add_child(game_track_player)
	output_latency = AudioServer.get_output_latency()


func queue_game_track(count_in: int) -> void:
	if not game_track:
		push_error("Tried to queue game track which is null")
		return
	queued = true
	if count_in:
		do_count_in(count_in)
	var time_until_play := count_in * pulse
	track_begin_time = Time.get_ticks_msec() / 1000.0 + time_until_play
	await get_tree().create_timer(time_until_play).timeout
	game_track_player.play()
	on_play.emit()


func do_count_in(count_in: int) -> void:
	while count_in > 0:
		on_count_in.emit(count_in)
		await get_tree().create_timer(pulse).timeout
		count_in -= 1


func _set_game_track(value: AudioStreamOggVorbis) -> void:
	if game_track == value:
		return
	game_track = value
	game_track_player.stream = game_track
	pulse = 60.0 / game_track.bpm


func _get_seek() -> float:
	if game_track_player.playing:
		return (game_track_player.get_playback_position()
				+ AudioServer.get_time_since_last_mix()
				- output_latency)
	if queued:
		return Time.get_ticks_msec() / 1000.0 - track_begin_time
	return -INF

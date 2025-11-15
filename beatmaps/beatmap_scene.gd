extends Node2D


@export var beatmap: Beatmap

@onready var metronome: AudioStreamPlayer = $Metronome


func _ready() -> void:
	TouchInputManager.screen_touch_pressed.connect(func(pos):
		BeatmapPlayer.attempt_hit_target())
	MusicPlayer.on_count_in.connect(func(count):
		metronome.pitch_scale = 1.5 if count % 4 == 0 else 1
		metronome.play())
		
	await get_tree().create_timer(1).timeout
	
	BeatmapPlayer.beatmap = beatmap
	BeatmapPlayer.queue_beatmap()

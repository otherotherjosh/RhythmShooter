extends Node2D


@export var beatmap: Beatmap


func _ready() -> void:
	BeatmapPlayer.beatmap = beatmap
	BeatmapPlayer.queue_beatmap()
	TouchInputManager.screen_touch_pressed.connect(func(pos):
		BeatmapPlayer.attempt_hit_target())

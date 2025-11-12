extends Node2D


@export var beatmap: Beatmap


func _ready() -> void:
	BeatmapPlayer.beatmap = beatmap
	BeatmapPlayer.queue_beatmap()

class_name Beatmap extends Resource
## Collection of beat targets to play in sync with an audio track


## Audio to sync with
@export var track: AudioStreamOggVorbis
## Beat targets
@export var targets: Array[BeatTarget]
## Colors to use for beat targets on the circle
@export var colors: Array[Color]


func sort_targets() -> void:
	targets.sort_custom(func(a: BeatTarget, b: BeatTarget):
		return a.beat < b.beat or a.beat == b.beat and a.measure < b.measure)

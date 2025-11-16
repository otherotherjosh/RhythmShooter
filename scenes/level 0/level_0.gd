extends Node2D


@export var events: Array[GameplayEvent]

@onready var beat_target_circle: BeatTargetCircle = $Parallax2D/BeatTargetCircle
@onready var dialogue_box: DialogueBox = $UI/DialogueBox


func _ready() -> void:
	beat_target_circle.global_position.x = 0
	beat_target_circle.shader_material.set_shader_parameter("alpha", 0.3)
	for event in events:
		if event is DialogueScript:
			dialogue_box.dialogue_script = event
			dialogue_box.play_dialogue()
		elif event is Beatmap:
			BeatmapPlayer.beatmap = event
			BeatmapPlayer.queue_beatmap()
		elif event is GameplayEventDelay:
			event.delay()
		await event.complete

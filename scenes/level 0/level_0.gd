extends Node2D


@export var events: Array[Resource]

@onready var beat_target_circle: BeatTargetCircle = $Parallax2D/BeatTargetCircle


func _ready() -> void:
	beat_target_circle.global_position.x = 0
	beat_target_circle.shader_material.set_shader_parameter("alpha", 0.3)

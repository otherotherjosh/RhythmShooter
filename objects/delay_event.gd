class_name GameplayEventDelay extends GameplayEvent


@export var duration: float = 1


func delay() -> void:
	await get_local_scene().get_tree().create_timer(duration).timeout
	complete.emit()

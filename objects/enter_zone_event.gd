class_name GameplayEventEnterZone extends GameplayEvent


@export var position: Vector2
@export var radius: float


func do_event() -> void:
	while CombatManager.player.position.distance_to(position) > radius:
		await get_local_scene().get_tree().process_frame
	complete.emit()

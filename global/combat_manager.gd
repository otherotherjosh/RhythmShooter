extends Node
## PvE event bus and management center


signal player_started_shooting
signal player_stopped_shooting
signal spawn_enemy(spawnpoint: int)

var enemy_aimed_at: Enemy
var player_is_shooting: bool
var player: Player


# Calls event and sends damage to the enemy being aimed at
func player_start_shooting() -> void:
	player_is_shooting = true
	player_started_shooting.emit()
	if enemy_aimed_at:
		enemy_aimed_at.start_taking_damage()


# Calls event and finishes sending damage to the enemy being aimed at
func player_stop_shooting() -> void:
	player_is_shooting = false
	player_stopped_shooting.emit()
	if enemy_aimed_at:
		enemy_aimed_at.stop_taking_damage()

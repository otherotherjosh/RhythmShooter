class_name CombatManager extends Node


signal player_started_shooting
signal player_stopped_shooting

var enemy_aimed_at: Enemy
var player_is_shooting: bool


func player_start_shooting() -> void:
	player_is_shooting = true
	player_started_shooting.emit()
	if enemy_aimed_at:
		enemy_aimed_at.start_taking_damage()


func player_stop_shooting() -> void:
	player_is_shooting = false
	player_stopped_shooting.emit()
	if enemy_aimed_at:
		enemy_aimed_at.stop_taking_damage()

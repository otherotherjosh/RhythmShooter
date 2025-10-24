class_name CombatManager extends Node


var enemy_aimed_at: Enemy

signal player_started_shooting
signal player_stopped_shooting


func player_start_shooting() -> void:
	player_started_shooting.emit()
	if enemy_aimed_at:
		enemy_aimed_at.start_taking_damage()


func player_stop_shooting() -> void:
	player_stopped_shooting.emit()
	if enemy_aimed_at:
		enemy_aimed_at.stop_taking_damage()

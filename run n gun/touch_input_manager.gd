class_name TouchInputManager extends Node


var player_move_direction: float:
	set = _set_player_move_direction


func _set_player_move_direction(value: float) -> void:
	player_move_direction = clampf(value, -1, 1)

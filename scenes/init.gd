extends Node2D


func _ready() -> void:
	get_tree().change_scene_to_packed(Global.SCENE_MENU)

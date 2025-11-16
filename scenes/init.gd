extends Node2D


func _ready() -> void:
	await get_tree().process_frame
	var scene = Global.SCENE_INTRO if Global.save["first_time"] else Global.SCENE_MENU
	Global.write_to_save("first_time", false)
	get_tree().change_scene_to_packed(scene)

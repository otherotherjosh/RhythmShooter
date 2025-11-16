extends Control


func _on_button_play() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(Global.SCENE_INTRO)


func _on_button_quit() -> void:
	get_tree().quit()

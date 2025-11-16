extends Control


func _on_button_play() -> void:
	get_tree().change_scene_to_file("res://scenes/intro/intro.tscn")


func _on_button_quit() -> void:
	get_tree().quit()

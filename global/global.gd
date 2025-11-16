extends Node


const SCENE_MENU := preload("res://scenes/menu/main_menu.tscn")
const SCENE_INTRO := preload("res://scenes/intro/intro.tscn")
const SAVE_DATA_PATH := "user://save_data.json"

var save: Dictionary


func _ready() -> void:
	if not FileAccess.file_exists(SAVE_DATA_PATH):
		init_save_data()
		return
	# load save data


func init_save_data() -> void:
	save = {
		"first-time" : true,
	}

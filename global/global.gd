extends Node


const SCENE_MENU := preload("res://scenes/menu/main_menu.tscn")
const SCENE_INTRO := preload("res://scenes/intro/intro.tscn")
const SAVE_DATA_PATH := "user://save_data.json"

var save: Dictionary:
	set = _set_save


func _ready() -> void:
	if not FileAccess.file_exists(SAVE_DATA_PATH):
		init_save_data()
		return
	load_save_data()


func init_save_data() -> void:
	save = {
		"first_time" : true,
	}


func load_save_data() -> void:
	var save_file: JSON = load(SAVE_DATA_PATH)
	save = save_file.data


func write_to_save(key: String, value: Variant) -> void:
	save[key] = value
	export_save_file()


func export_save_file() -> void:
	var file := FileAccess.open(SAVE_DATA_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(save)
	file.store_line(json_string)
	file.close()


func _set_save(value: Dictionary) -> void:
	if save == value: return
	save = value
	export_save_file()

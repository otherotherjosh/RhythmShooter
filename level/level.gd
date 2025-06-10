class_name Level extends Node2D
## Handles top level level behavior


## Player score
var score: int:
	set = set_score

## Score label in HUD
@onready var score_label: Label = $UI/Score


func _on_note_player_note_smashed(note_score: int) -> void:
	score += note_score


func set_score(value: int) -> void:
	score = value
	score_label.text = "%s" % score
	

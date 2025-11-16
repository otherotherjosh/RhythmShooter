class_name Dialogue extends Resource


enum Character {
	PLAYER,
	Q,
}

enum Emotion {
	NEUTRAL,
	HAPPY,
}

const SPRITE_PATH = "res://dialogue/sprites/characters"

@export var character: Character
@export var emotion: Emotion
@export var text: String

var character_sprite: Texture2D:
	get:
		var character_name: String = Character.keys()[character]
		var emotion_name: String = Emotion.keys()[emotion]
		var path := "%s/%s_%s.png" % [SPRITE_PATH, character_name, emotion_name]
		if FileAccess.file_exists(path):
			return load(path)
		# fall back to neutral if emotion does not have a sprite
		return load("%s/%s_NEUTRAL.png" % [SPRITE_PATH, character_name])

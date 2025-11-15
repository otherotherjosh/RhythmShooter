class_name Dialogue extends Resource


enum Character {
	PLAYER,
	Q,
}

enum Emotion {
	NEUTRAL,
}

@export var character: Character
@export var emotion: Emotion
@export var text: String

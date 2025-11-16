class_name DialogueScript extends GameplayEvent


enum Timing {
	SKIPPABLE,
	SCRIPTED,
}

@export var lines: Array[Dialogue]
@export var timing: Timing

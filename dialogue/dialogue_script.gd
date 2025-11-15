class_name DialogueScript extends Resource


enum Timing {
	SKIPPABLE,
	SCRIPTED,
}

@export var lines: Array[Dialogue]
@export var timing: Timing

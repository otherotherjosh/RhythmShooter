class_name BeatTarget extends Resource
## Defines a point in time, synchronized to music, to be hit by player


enum State {
	INACTIVE,
	READY,
	HIT,
	MISSED,
}

## Beat (quarter note) number 
@export var beat: int = 0
## Fractional beat offset (0 = on the beat, 1 = the next beat)
@export var measure: float = 0
## Color to show on beat target circle
@export var color: int

var state: State = State.INACTIVE

class_name Enemy extends CharacterBody2D


enum State {
	IDLE,
	RUNNING,
	ATTACKING,
	HURTING,
	DYING,
}

@export var health: float = 100
@export var modulate_hurt: Color = Color.WHITE
## temporary; while dying animation does not exist
@export var modulate_dying: Color = Color.WHITE

var state: State = State.IDLE


func _process(delta: float) -> void:
	modulate = calc_modulate()


func calc_modulate() -> Color:
	match state:
		State.HURTING:
			return modulate_hurt
		State.DYING:
			return modulate_dying
	return Color.WHITE


func start_taking_damage() -> void:
	state = State.HURTING
	# do pain animation


func stop_taking_damage() -> void:
	state = State.IDLE


func die() -> void:
	state = State.DYING
	# do dying animation

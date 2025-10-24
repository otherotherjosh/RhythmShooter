class_name Enemy extends CharacterBody2D


enum State {
	IDLE,
	RUNNING,
	ATTACKING,
	HURTING,
	DYING,
}

@export var health: int = 1:
	set = _set_health
@export var modulate_hurt: Color = Color.WHITE
## temporary; while dying animation does not exist
@export var modulate_dying: Color = Color.WHITE

var state: State = State.IDLE

@onready var combat_manager: CombatManager = %CombatManager


func _process(_delta: float) -> void:
	modulate = calc_modulate()


func calc_modulate() -> Color:
	match state:
		State.HURTING:
			return modulate_hurt
		State.DYING:
			return modulate_dying
	return Color.WHITE


func start_taking_damage() -> void:
	if state == State.DYING:
		return
	state = State.HURTING
	# do pain animation


func stop_taking_damage() -> void:
	if state == State.DYING:
		return
	state = State.IDLE
	health -= 1


func die() -> void:
	state = State.DYING
	# do dying animation
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _set_health(value: int) -> void:
	health = value
	if health == 0:
		die()

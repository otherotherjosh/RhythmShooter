class_name Enemy extends CharacterBody2D
## Shootable character with variable health, designed to be shot.
## Is generally quite good at receiving damage upon becoming the target of a shooting


enum State {
	IDLE,
	RUNNING,
	ATTACKING,
	HURTING,
	DYING,
}

## Number of shots required to kill
@export var health: int = 1:
	set = _set_health
## Color to modulate when getting hurt
@export var modulate_hurt: Color = Color.WHITE
## temporary; while dying animation does not exist
@export var modulate_dying: Color = Color.WHITE

var state: State = State.IDLE

@onready var combat_manager: CombatManager = %CombatManager


## Begins animation and process of getting damaged
func start_taking_damage() -> void:
	if state == State.DYING:
		return
	state = State.HURTING
	# do pain animation
	modulate = modulate_hurt


## Stops animation and finalizes process of getting damaged
func stop_taking_damage() -> void:
	if state == State.DYING:
		return
	# set modulate back to normal
	modulate = Color.WHITE
	state = State.IDLE
	health -= 1


# Die
func die() -> void:
	state = State.DYING
	# do dying animation
	modulate = modulate_dying
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _set_health(value: int) -> void:
	health = value
	if health == 0:
		die()

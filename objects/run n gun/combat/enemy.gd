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

const SPEED := 100
const ACCELERATION := 250

## Number of shots required to kill
@export var health: int = 1:
	set = _set_health
## Color to modulate when getting hurt
@export var modulate_hurt: Color = Color.WHITE
## temporary; while dying animation does not exist
@export var modulate_dying: Color = Color.WHITE
## How far from player to stand and attack
@export var attack_distance: int = 80
## How far from player is too close to attack
@export var back_up_distance: int = 50

var state: State = State.IDLE


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction := -1 if CombatManager.player.global_position.x < global_position.x else 1
	
	if global_position.distance_to(CombatManager.player.global_position) <= back_up_distance:
		velocity.x = move_toward(velocity.x, -direction * SPEED, delta * ACCELERATION)
	elif global_position.distance_to(CombatManager.player.global_position) <= attack_distance:
		velocity.x = move_toward(velocity.x, 0, delta * ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, direction * SPEED, delta * ACCELERATION)
	
	move_and_slide()


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

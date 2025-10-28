extends Node
## Spawns enemies when (and where) instructed


## Enemy base prefab
const ENEMY = preload("res://run n gun/combat/enemy.tscn")

## temporary: while external calling of spawn_enemy does not exist
@onready var enemy_spawnpoint: EnemySpawnpoint = $EnemySpawnpoint


# TODO: remove this
func _ready() -> void:
	while true:
		await get_tree().create_timer(1).timeout
		spawn_enemy(2, enemy_spawnpoint)


## Spawns enemy with specified amount of health at a spawnpoint
func spawn_enemy(health: int, spawnpoint: EnemySpawnpoint):
	var enemy: Enemy = ENEMY.instantiate()
	enemy.health = health
	enemy.global_position = spawnpoint.global_position
	add_child(enemy)

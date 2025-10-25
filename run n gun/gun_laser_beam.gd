class_name GunLaserBeam extends Sprite2D


enum State {
	IDLE,
	FIRING,
}

@export var animation_steps: Array[GunLaserBeamAnimationStep]

var state: State
var shader: ShaderMaterial
var enemy_shooting_at: Enemy

@onready var frame_timer: Timer = $FrameTimer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var combat_manager: CombatManager = %CombatManager


func _ready() -> void:
	shader = material
	visible = false


func aim_at_hit(collider: Object) -> void: 
	if collider is Enemy:
		combat_manager.enemy_aimed_at = collider
	else:
		combat_manager.enemy_aimed_at = null
	var hit := ray_cast_2d.get_collision_point()
	var distance := global_position.distance_to(hit)
	var distance_frac := distance / texture.get_width() as float
	shader.set_shader_parameter("length", distance_frac)


func start_shooting() -> void:
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		var collider := ray_cast_2d.get_collider()
		aim_at_hit(collider)
	else:
		combat_manager.enemy_aimed_at = null
		shader.set_shader_parameter("length", 1)
	
	state = State.FIRING
	visible = true
	
	for step in animation_steps:
		if state == State.IDLE:
			return
		apply_shader_params(step)
		frame_timer.start()
		await frame_timer.timeout


func stop_shooting() -> void:
	state = State.IDLE
	visible = false


func apply_shader_params(step: GunLaserBeamAnimationStep) -> void:
	shader.set_shader_parameter("width", step.width)
	shader.set_shader_parameter("wave_height", step.wave_height)
	shader.set_shader_parameter("start_zone", step.start_zone)

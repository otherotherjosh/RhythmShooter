class_name GunLaserBeam extends Sprite2D


enum State {
	IDLE,
	FIRING,
}

@export var animation_steps: Array[GunLaserBeamAnimationStep]

var state: State
var shader: ShaderMaterial

@onready var frame_timer: Timer = $FrameTimer
@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _ready() -> void:
	shader = material
	visible = false


func _process(delta: float) -> void:
	if ray_cast_2d.is_colliding():
		var collision := ray_cast_2d.get_collider()
		if collision is Enemy:
			aim_at_enemy(collision)
			return
	shader.set_shader_parameter("length", 1)


# TODO: aim_at_hit() not enemy
func aim_at_enemy(enemy: Enemy) -> void: 
	var hit := ray_cast_2d.get_collision_point()
	var distance := global_position.distance_to(hit)
	var distance_frac := distance / texture.get_width() as float
	shader.set_shader_parameter("length", distance_frac)
	# TODO: remove reference to enemy here and 
	enemy.state = Enemy.State.HURTING if state == State.FIRING else Enemy.State.IDLE


func start_shooting() -> void:
	state = State.FIRING
	visible = true
	for step in animation_steps:
		if state == State.IDLE:
			return
		apply_shader_params(step)
		frame_timer.start()
		await frame_timer.timeout


func end_shooting() -> void:
	state = State.IDLE
	visible = false


func apply_shader_params(step: GunLaserBeamAnimationStep) -> void:
	shader.set_shader_parameter("width", step.width)
	shader.set_shader_parameter("wave_height", step.wave_height)
	shader.set_shader_parameter("start_zone", step.start_zone)

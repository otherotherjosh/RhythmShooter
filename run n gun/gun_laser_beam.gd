class_name GunLaserBeam extends Sprite2D


enum State {
	IDLE,
	FIRING,
}

@export var animation_steps: Array[GunLaserBeamAnimationStep]

var state: State
var shader: ShaderMaterial

@onready var frame_timer: Timer = $FrameTimer


func _ready() -> void:
	shader = material
	visible = false


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

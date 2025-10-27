class_name GunLaserBeam extends Sprite2D
## Animated beam that fires in a straight line from the dubstep gun.
## Intersects with enemies and reports them to Combat Manager


enum State {
	IDLE,
	FIRING,
}

## Frames in sequential order to animate when gun is fired
@export var animation_frames: Array[GunLaserBeamAnimationFrame]

var state: State
## Beam shader with parameters, e.g. width and wave_height
var shader: ShaderMaterial

@onready var combat_manager: CombatManager = %CombatManager
@onready var frame_timer: Timer = $FrameTimer
@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _ready() -> void:
	shader = material
	visible = false


## Animates beam and reports colliding enemy to Combat Manager
func start_shooting() -> void:
	check_ray_cast_collision()
	state = State.FIRING
	visible = true
	play_shoot_animation()


## Make beam invisible
func stop_shooting() -> void:
	state = State.IDLE
	visible = false


## Checks for any collider intersecting the beam. Aims at any collision, otherwise reports to
## Combat Manager that there is no enemy in shot
func check_ray_cast_collision() -> void:
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		var collider := ray_cast_2d.get_collider()
		aim_at_ray_cast_collision(collider)
	else:
		combat_manager.enemy_aimed_at = null
		shader.set_shader_parameter("length", 1)


## Checks if beam is hitting an enemy and sets the beam length to not overshoot collision
func aim_at_ray_cast_collision(collider: Object) -> void: 
	if collider is Enemy:
		combat_manager.enemy_aimed_at = collider
	else:
		combat_manager.enemy_aimed_at = null
	var hit := ray_cast_2d.get_collision_point()
	var distance := global_position.distance_to(hit)
	var distance_frac := distance / texture.get_width() as float
	shader.set_shader_parameter("length", distance_frac)


## Iterates over animation frames, but will be interrupted if shooting stops
func play_shoot_animation() -> void:
	for frame in animation_frames:
		if state == State.IDLE:
			return
		apply_shader_params(frame)
		frame_timer.start()
		await frame_timer.timeout


## Takes the parameter values defined in an animation frame and sets them on the shader
func apply_shader_params(frame: GunLaserBeamAnimationFrame) -> void:
	shader.set_shader_parameter("width", frame.width)
	shader.set_shader_parameter("wave_height", frame.wave_height)
	shader.set_shader_parameter("start_zone", frame.start_zone)

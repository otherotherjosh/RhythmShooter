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


func _process(_delta: float) -> void:
	if state == State.FIRING and ray_cast_2d.is_colliding():
		check_ray_cast_collision()


## Animates beam and reports colliding enemy to Combat Manager
func start_shooting() -> void:
	state = State.FIRING
	visible = true
	play_shoot_animation()
	check_ray_cast_collision()


## Make beam invisible
func stop_shooting() -> void:
	state = State.IDLE
	visible = false


## Iterates over animation frames, but will be interrupted if shooting stops
func play_shoot_animation() -> void:
	for animation_frame in animation_frames:
		if state == State.IDLE:
			return
		apply_shader_params(animation_frame)
		frame_timer.start()
		await frame_timer.timeout


## Checks for any collider intersecting the beam. Aims at any collision, otherwise reports to
## Combat Manager that there is no enemy in shot
func check_ray_cast_collision() -> void:
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		var collider := ray_cast_2d.get_collider()
		aim_at_ray_cast_collision(collider)
		beam_length_to_collision()
	else:
		combat_manager.enemy_aimed_at = null
		shader.set_shader_parameter("length", 1)


## Checks if collider beam is hitting belongs to an enemy
func aim_at_ray_cast_collision(collider: Object) -> void: 
	if collider is Enemy:
		combat_manager.enemy_aimed_at = collider
	else:
		combat_manager.enemy_aimed_at = null


## Sets the beam length to not overshoot collision
func beam_length_to_collision() -> void:
	var hit := ray_cast_2d.get_collision_point()
	var distance := global_position.distance_to(hit)
	var distance_frac := distance / texture.get_width() as float
	shader.set_shader_parameter("length", distance_frac)


## Takes the parameter values defined in an animation frame and sets them on the shader
func apply_shader_params(animation_frame: GunLaserBeamAnimationFrame) -> void:
	shader.set_shader_parameter("width", animation_frame.width)
	shader.set_shader_parameter("wave_height", animation_frame.wave_height)
	shader.set_shader_parameter("start_zone", animation_frame.start_zone)

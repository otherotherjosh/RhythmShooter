extends Sprite2D


const TEST_DELAY = 0.5
const ANTICIPATE_TIME = 2.0
const GLOW_MULTIPLIER_ON_TARGET = 1.3
const GLOW_MULTIPLIER_LERP_SPEED = 6

var next_beat_target: int
var glow_multiplier: float
var shader_material: ShaderMaterial


func _ready() -> void:
	BeatmapPlayer.on_queue.connect(_on_beatmap_player_queue)
	BeatmapPlayer.on_target.connect(_on_beatmap_player_target)
	shader_material = material


func _process(delta: float) -> void:
	shader_material.set_shader_parameter("glow_multiplier", glow_multiplier)
	glow_multiplier = lerpf(glow_multiplier, 1, delta * GLOW_MULTIPLIER_LERP_SPEED)
	
	if next_beat_target >= BeatmapPlayer.targets.size(): return
	if BeatmapPlayer.time_to_target(next_beat_target) <= ANTICIPATE_TIME:
		add_circle(next_beat_target)
		next_beat_target += 1


func add_circle(target_index: int) -> void:
	var shader_material := ShaderMaterial.new()
	shader_material.shader = material.shader
	var target := BeatmapPlayer.targets[target_index]
	var color := BeatmapPlayer.beatmap.colors[target.color]
	shader_material.set_shader_parameter("color", Vector3(color.r, color.g, color.b))
	
	var circle := Circle.new(target_index, shader_material)
	add_child(circle)
	
	circle.texture = texture
	circle.scale = Vector2.ONE
	circle.show_behind_parent = true
	circle.position = Vector2.ZERO


func _on_beatmap_player_queue() -> void:
	next_beat_target = 0


func _on_beatmap_player_target() -> void:
	glow_multiplier = GLOW_MULTIPLIER_ON_TARGET


class Circle extends Sprite2D:
	
	const FALLOUT_SPEED := 0.75
	
	var target_index: int
	var target: BeatTarget:
		get = _get_target
	var shader_material: ShaderMaterial
	var start_time: float
	var projected_time: float
	
	
	func _init(_target_index: int, _shader_material: ShaderMaterial) -> void:
		target_index = _target_index
		shader_material = _shader_material
		material = shader_material
	
	
	func _ready() -> void:
		start_time = MusicPlayer.seek
		projected_time = BeatmapPlayer.time_of_target(target_index)
		shader_material.set_shader_parameter("scale", 0)
	
	
	func _process(delta: float) -> void:
		var time := MusicPlayer.seek
		
		# grow circle in anticipation of target time
		if projected_time > time and target.state != BeatTarget.State.HIT:
			var c_scale := inverse_lerp(start_time, projected_time, time)
			shader_material.set_shader_parameter("scale", c_scale)
			return
		
		match target.state:
			BeatTarget.State.READY:
				shader_material.set_shader_parameter("scale", 1)
				return
			BeatTarget.State.MISSED:
				queue_free()
				return
		
		# grow circle after target hit
		var c_scale: float = shader_material.get_shader_parameter("scale")
		c_scale += delta * FALLOUT_SPEED
		shader_material.set_shader_parameter("scale", c_scale)
		if c_scale >= 2:
			queue_free()
			return
	
	
	func _get_target() -> BeatTarget:
		return BeatmapPlayer.targets[target_index]

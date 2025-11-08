extends Sprite2D


const TEST_DELAY = 0.5

var circles: Array[Sprite2D]


func _ready() -> void: # TEST
	while true:
		add_circle()
		await get_tree().create_timer(TEST_DELAY).timeout


func _process(delta: float) -> void:
	for circle in circles:
		var c_shader := circle.material as ShaderMaterial
		var c_scale: float = c_shader.get_shader_parameter("scale")
		if c_scale >= 2:
			circles.pop_front()
			circle.queue_free()
			continue
		c_scale += delta * 0.5
		c_shader.set_shader_parameter("scale", c_scale)


func add_circle() -> void:
	var circle := Sprite2D.new()
	add_child(circle)
	circle.texture = texture
	circle.scale = Vector2.ONE
	circle.show_behind_parent = true
	circle.material = ShaderMaterial.new()
	circle.position = Vector2.ZERO
	var c_shader := circle.material as ShaderMaterial
	c_shader.shader = material.shader
	c_shader.set_shader_parameter("scale", 0)
	var color := Vector3(randf(), randf(), randf())
	c_shader.set_shader_parameter("color", color)
	circles.append(circle)

shader_type canvas_item;

uniform int random_seed = 0;
uniform float width = 10;
uniform float falloff = 50;
uniform float waves = 50;
uniform float wave_height = 0.1;
uniform float wave_speed = 50;
uniform float waves_2 = 72;
uniform float wave_2_height = 0.06;
uniform float wave_2_speed = 72;
uniform float start_zone = 0.1;
uniform float start_scale = 0.2;

float get_scale(float uv_x) {
	if (uv_x < start_zone) {
		return uv_x / start_zone;
	}
	return 1.0;
}

void fragment() {
	COLOR = vec4(UV, 1.0, 1.0); 
	float scale = get_scale(UV.x);
	float wave_sum = sin(UV.x * waves - TIME * wave_speed) + sin(UV.x * waves_2 - TIME * wave_2_speed);
	float wave_center = 0.5 + wave_height * scale * wave_sum;
	float distance_to_center = abs(UV.y - wave_center);
	COLOR.a = width * scale - falloff * distance_to_center;
}

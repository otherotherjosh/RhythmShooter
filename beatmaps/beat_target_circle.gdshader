shader_type canvas_item;

uniform vec3 color = vec3(1);
uniform float scale = 0;
uniform float glow_multiplier = 1;

const float TARGET_RADIUS = 0.2;
const float TARGET_WIDTH = 0.004;
const float GLOW_STRENGTH = 0.9;
const float GLOW_FALLOFF = 0.05;
const vec2 CENTER = vec2(0.5, 0.5);

float vec2_distance(vec2 a, vec2 b) {
	return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}

vec4 draw_circle(float uv_center_distance, float radius, float width) {
	width /= 2.0;
	if (radius - width <= uv_center_distance && uv_center_distance <= radius + width) {
		return vec4(color, 1);
	}
	return vec4(0);
}

vec4 draw_circle_glow(float uv_center_distance, float radius) {
	float glow_strength = GLOW_STRENGTH - abs(radius - uv_center_distance) / GLOW_FALLOFF;
	glow_strength *= glow_multiplier;
	return vec4(color, pow(glow_strength, 5));
}

void fragment() {
	float uv_center_distance = vec2_distance(UV, CENTER);
	float radius = TARGET_RADIUS;
	float alpha_mult = 1.0;
	if (scale < 1.0) {
		radius *= pow(scale, 2.5);
		alpha_mult = pow(scale, 1.5);
	} else {
		radius *= scale;
		alpha_mult = 1.0 - (scale - 1.0);
	}
	COLOR = draw_circle(uv_center_distance, radius, TARGET_WIDTH);
	COLOR += draw_circle_glow(uv_center_distance, radius);
	COLOR.a = clamp(COLOR.a, 0, 1);
	COLOR.a *= alpha_mult;
}

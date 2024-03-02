shader_type spatial;
uniform float strength = 0.0;

void fragment() {
	ALBEDO = vec3(1.0, 1.0, 1.0);
	ALPHA = strength;
}

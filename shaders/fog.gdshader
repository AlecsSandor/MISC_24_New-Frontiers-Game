//shader_type spatial;

shader_type fog;

uniform float radius1 = 7.0;
uniform float radius2 = 0.5;
uniform float noise_intensity = 3.0;
uniform float density = 0.1;
uniform float spin_speed = 0.5;
uniform vec3 color:source_color = vec3(2.0);
uniform sampler3D noise;

// from inigo's website
float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

void fog() {
	vec3 pos = WORLD_POSITION - OBJECT_POSITION;
	
	// Rotating coordinates for spinning noise
	vec3 coord = pos;
	float rot = radians(0.0);
	rot = TIME * spin_speed;
	mat2 m = mat2( vec2( cos(rot), -sin(rot) ), vec2( sin(rot), cos(rot) ) );
	vec2 coord_rot_xz = coord.xz * m;
	coord = vec3(coord_rot_xz.x, coord.y, coord_rot_xz.y);
	
	// SDF for torus drives density offset by noise (if less than 0, output 1 for density)
	DENSITY = float(sdTorus(pos, vec2(radius1,radius2)) - (texture(noise, coord).b * noise_intensity) < 0.0) * density;
	ALBEDO = color;
}

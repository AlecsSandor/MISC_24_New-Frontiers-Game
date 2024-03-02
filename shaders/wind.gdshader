shader_type spatial;

uniform float speed = 0.7;
uniform float dis = 0.3;

uniform vec4 main_color : source_color;

void vertex(){
 	VERTEX.x += sin(TIME * speed) * dis * (UV.y-1.0);
	VERTEX.z += sin(TIME * speed) * dis * (UV.y-1.0);
}

void fragment()
{
	ALBEDO = main_color.rgb;
}

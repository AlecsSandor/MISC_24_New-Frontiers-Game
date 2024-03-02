shader_type spatial;

uniform float speed = 0.7;
uniform float dis = 0.3;
uniform vec4 main_color : source_color;
uniform vec4 outline_color : source_color;
uniform float outline_width = 1.0;

void vertex() {
    // Apply wind movement
    VERTEX.x += sin(TIME * speed) * dis * (UV.y - 1.0);
    VERTEX.z += sin(TIME * speed) * dis * (UV.y - 1.0);

    // Apply outline effect
    vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
    vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);

    vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;
    clip_position.xy += offset;
    POSITION = clip_position;
}

void fragment() {
    // Check if outline should be applied based on outline_color alpha.
    if (outline_color.a < 1.0) {
        ALBEDO = outline_color.rgb;
        ALPHA = outline_color.a;
    } else {
        ALBEDO = main_color.rgb;
    }
}

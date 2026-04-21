shader_type canvas_item;

uniform vec4 color_start : source_color = vec4(1.0, 0.0, 0.0, 1.0);   // Red
uniform vec4 color_end   : source_color = vec4(1.0, 0.5, 0.0, 1.0);   // Orange

void fragment() {
    float t = pow(UV.x, 0.2); // Horizontal gradient
    vec4 gradient_color = mix(color_start, color_end, t);

    // Sample the glyph texture
    vec4 tex = texture(TEXTURE, UV);

    // Apply gradient but preserve the glyph alpha
    COLOR.rgb = gradient_color.rgb * tex.a;
    COLOR.a = tex.a;
}

shader_type canvas_item;

uniform vec4 color_start : source_color = vec4(1.0, 0.0, 0.0, 2.0);
uniform vec4 color_end : source_color = vec4(1.0, 0.5, 0.0, 2.0);

void fragment() {
    // Get the UV coordinate relative to the whole control
    float t = UV.x; // Horizontal gradient
    vec4 gradient_color = mix(color_start, color_end, t);

    // Multiply the gradient with the existing text color
    COLOR = texture(TEXTURE, UV) * gradient_color;
}

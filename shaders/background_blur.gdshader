shader_type canvas_item;

uniform  sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;
uniform float amount: hint_range(0.0, 1.0, 0.1);
const float darken_amount = 0.05;

void fragment() {
	vec4 color = textureLod(screen_texture, SCREEN_UV, amount) - darken_amount;
	color.a = 1.0; // Fix to apply blur on HDRIs
	COLOR = color;
}

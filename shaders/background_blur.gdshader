shader_type canvas_item;

uniform  sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;
uniform float amount: hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 color = textureLod(screen_texture, SCREEN_UV, 1.0);
	COLOR = vec4(color.rgb, 1.0); // Fix to apply blur on HDRIs
}

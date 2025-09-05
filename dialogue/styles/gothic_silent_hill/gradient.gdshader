shader_type canvas_item;

uniform vec4 top_color : source_color = vec4(0.75, 0.75, 0.75, 1.0); // Silver
uniform vec4 bottom_color : source_color = vec4(1.0); // White
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.75); // Black with some transparency
uniform vec2 shadow_offset = vec2(2e-3, 2e-3);

uniform float shadow_threshold = 1e-2;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 shadow_texture_color = texture(TEXTURE, UV - shadow_offset);
	
	vec4 final_color = vec4(0.0);
	
	// Only apply shadow if we have enough transparency that it exceeds our threshold.
	if (shadow_texture_color.a > shadow_threshold)
	{
		final_color.rgb = shadow_color.rgb;
		// mixing the alphas is a multiply
		final_color.a = shadow_texture_color.a * shadow_color.a;
	}
	
	if (texture_color.a > 0.01)
	{
		float mix_factor = clamp(UV.x, 0.0, 1.0);
		vec4 gradient_color = mix(top_color, bottom_color, mix_factor);
		final_color.rgb = mix(final_color.rgb, gradient_color.rgb, texture_color.a);
		final_color.a = max(final_color.a, texture_color.a);
	}
		
	
	COLOR = final_color;
}
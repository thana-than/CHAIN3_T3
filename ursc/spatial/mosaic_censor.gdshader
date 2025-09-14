shader_type spatial;
render_mode blend_mix, unshaded, cull_back;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Mosaic controls
uniform float mosaic_pixel_size = 4.0;

void fragment() {
	// setup the mask as something
	//float mask = 1.0 - pow(clamp(base_col.a, 0.0, 1.0), mask_sharpness);

	vec2 suv = SCREEN_UV;

	// get pixels and quantize
	vec2 vp = vec2(VIEWPORT_SIZE); // viewport resolution
	vec2 px_uv = suv * vp;
	vec2 q = floor(px_uv / mosaic_pixel_size) * mosaic_pixel_size + (mosaic_pixel_size * 0.5);
	vec2 mosaic_uv = q / vp;

	vec3 sampled_rgb = texture(screen_texture, mosaic_uv).rgb;

	EMISSION = sampled_rgb;
	ALBEDO = sampled_rgb;
	ALPHA = 1.0;
}
shader_type fog;

uniform float density        : hint_range(0.0, 8.0, 0.0001) = 0.2;
uniform vec3  albedo_color   : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3  emission_color : source_color = vec3(0.0, 0.0, 0.0);
uniform float emission_energy : hint_range(0.0, 8.0, 0.0001) = 0.0;

uniform sampler3D noise_tex : hint_default_white, repeat_enable;
uniform float noise_strength : hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float noise_scale    : hint_range(0.0, 1.0, 0.001) = 0.08;
uniform vec3  noise_flow     = vec3(0.02, 0.0, 0.01);

uniform float height_falloff : hint_range(0.0, 8.0, 0.0001) = 0.0; // 0 = off
uniform float edge_fade      : hint_range(0.0, 4.0, 0.0001) = 1.0; // 1 = normal


void fog() {
	float d = 1.0;
	if (noise_strength > 0.0) {
        float n = texture(
            noise_tex,
            WORLD_POSITION * noise_scale + noise_flow * TIME
        ).r;
        d = mix(d, n, noise_strength); // blend noise into density
    }
	
	if (height_falloff > 0.0) {
        float h = clamp(exp2(-height_falloff * (WORLD_POSITION.y - OBJECT_POSITION.y)), 0.0, 1.0);
        d *= h;
    }
	float edge = clamp(-SDF / max(max(SIZE.x, SIZE.y), SIZE.z), 0.0, 1.0);
    d *= pow(edge, edge_fade);
	
	DENSITY = d * density;
    ALBEDO  = albedo_color;
    EMISSION = emission_color * emission_energy;
}

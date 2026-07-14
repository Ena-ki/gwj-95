shader_type canvas_item;

const int COLOR_AMOUNT = 4;

uniform float bloom_radius = 1.0;
// Lowered default threshold to 0.7 so SDR colors can actually bloom
uniform float bloom_threshold : hint_range(0.0, 1.0) = 0.7; 
uniform float bloom_intensity = 1.0;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;
uniform vec3 color_map[COLOR_AMOUNT] : source_color;

uniform float aspect : hint_range(0.5, 1.0) = 0.75;
uniform float curve : hint_range(0.0, 0.5) = 0.0;

// Harrison Allen's CRT warp function
vec2 warp(vec2 uv, float _aspect, float _curve)
{
	uv -= 0.5;
	uv.x /= _aspect;

	float warping = dot(uv, uv) * _curve;
	warping -= _curve * 0.25;

	uv /= 1.0 - warping;
	uv.x *= _aspect;
	uv += 0.5;

	return uv;
}

// Optimized: Combines quantization and color mapping into a single fast pass
vec3 quantize_and_map(vec3 col) {
	// Using standard perceptual weights for luminance (Red: 21%, Green: 71%, Blue: 7%)
	// This makes colors look much more natural than a flat average
	float lum = dot(col, vec3(0.2126, 0.7152, 0.0722));
	int index = int(clamp(floor(lum * float(COLOR_AMOUNT)), 0.0, float(COLOR_AMOUNT - 1)));
	return color_map[index];
}

// Safely thresholds color using luminance to prevent hue-shifting/color distortion
vec3 threshold_color(vec3 col, float threshold) {
	float lum = dot(col, vec3(0.2126, 0.7152, 0.0722));
	return col * max(lum - threshold, 0.0);
}

// Helper to fetch, clamp, quantize, and threshold a single pixel sample
vec3 get_bloom_sample(sampler2D tex, vec2 uv) {
	vec2 clamped_uv = clamp(uv, vec2(0.0), vec2(1.0));
	vec3 base_col = texture(tex, clamped_uv).rgb;
	vec3 mapped_col = quantize_and_map(base_col);
	return threshold_color(mapped_col, bloom_threshold);
}

// GhSoares' bilinear filtering, optimized to use our safe helper functions
vec3 get_bloom_pixel(sampler2D tex, vec2 uv, vec2 tex_pixel_size) {
	vec2 clamped_uv = clamp(uv, vec2(0.0), vec2(1.0));
	vec2 uv2 = floor(clamped_uv / tex_pixel_size) * tex_pixel_size;
	uv2 += tex_pixel_size * 0.001;

	vec3 tl = get_bloom_sample(tex, uv2);
	vec3 tr = get_bloom_sample(tex, uv2 + vec2(tex_pixel_size.x, 0.0));
	vec3 bl = get_bloom_sample(tex, uv2 + vec2(0.0, tex_pixel_size.y));
	vec3 br = get_bloom_sample(tex, uv2 + vec2(tex_pixel_size.x, tex_pixel_size.y));

	vec2 f = fract(clamped_uv / tex_pixel_size);
	vec3 tA = mix(tl, tr, f.x);
	vec3 tB = mix(bl, br, f.x);
	return mix(tA, tB, f.y);
}

// 3x3 Blur kernel
vec3 get_bloom(sampler2D tex, vec2 uv, vec2 tex_pixel_size) {
	vec3 bloom = vec3(0.0);
	vec2 off = vec2(1.0) * tex_pixel_size * bloom_radius;
	
	bloom += get_bloom_pixel(tex, uv + off * vec2(-1.0, -1.0), tex_pixel_size * bloom_radius) * 0.292893;
	bloom += get_bloom_pixel(tex, uv + off * vec2(-1.0,  0.0), tex_pixel_size * bloom_radius) * 0.5;
	bloom += get_bloom_pixel(tex, uv + off * vec2(-1.0,  1.0), tex_pixel_size * bloom_radius) * 0.292893;
	bloom += get_bloom_pixel(tex, uv + off * vec2( 0.0, -1.0), tex_pixel_size * bloom_radius) * 0.5;
	bloom += get_bloom_pixel(tex, uv + off * vec2( 0.0,  0.0), tex_pixel_size * bloom_radius) * 1.0;
	bloom += get_bloom_pixel(tex, uv + off * vec2( 0.0,  1.0), tex_pixel_size * bloom_radius) * 0.5;
	bloom += get_bloom_pixel(tex, uv + off * vec2( 1.0, -1.0), tex_pixel_size * bloom_radius) * 0.292893;
	bloom += get_bloom_pixel(tex, uv + off * vec2( 1.0,  0.0), tex_pixel_size * bloom_radius) * 0.5;
	bloom += get_bloom_pixel(tex, uv + off * vec2( 1.0,  1.0), tex_pixel_size * bloom_radius) * 0.292893;
	
	bloom /= 4.171573;
	return bloom;
}

void fragment() {
	// 1. WARPING
	vec2 warped_coords = warp(UV, aspect, curve);
	
	// 1b. Boundary check (creates the clean black CRT bezel)
	if (warped_coords.x < 0.0 || warped_coords.x > 1.0 || warped_coords.y < 0.0 || warped_coords.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
		return;
	}

	// 2. BASE COLOR SAMPLING
	vec4 col = texture(screen_texture, warped_coords);

	// 3. QUANTIZATION & COLOR MAPPING
	vec3 final_palette_color = quantize_and_map(col.rgb);

	// 4. BLOOM (Sampled from the warped coordinates)
	vec3 bloom = get_bloom(screen_texture, warped_coords, SCREEN_PIXEL_SIZE);

	// 5. COMBINE
	// The bloom glow is added to your mapped color, matching your sequence.
	COLOR = vec4(final_palette_color + (bloom * bloom_intensity), 1.0);
}
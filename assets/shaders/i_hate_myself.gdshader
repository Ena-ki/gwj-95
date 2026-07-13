shader_type canvas_item;

const int COLOR_AMOUNT = 4;

uniform float bloom_radius = 1.0;
uniform float bloom_threshold = 1.0;
uniform float bloom_intensity = 1.0;

uniform sampler2D screen_texture : hint_screen_texture;
uniform vec3 color_map[COLOR_AMOUNT] : source_color;

uniform float aspect : hint_range(0.5, 1.0) = 0.75;
uniform float curve : hint_range(0.0, 0.5) = 0.0;

// I'm too dumb to do shaders, so thanks to Harrison Allen for this function
// https://godotshaders.com/shader/crt-with-luminance-preservation/
vec2 warp(vec2 uv, float _aspect, float _curve)
{
	// Centralize coordinates
	uv -= 0.5;

	uv.x /= _aspect;

	// Squared distance from the middle
	float warping = dot(uv, uv) * _curve;

	// Compensate for shrinking
	warping -= _curve * 0.25;

	// Warp the coordinates
	uv /= 1.0 - warping;

	uv.x *= _aspect;

	// Decentralize the coordinates
	uv += 0.5;

	return uv;
}

vec3 map_colors(float lum){
  lum = clamp(lum, 0.0, 1.0);
  return color_map[min(COLOR_AMOUNT - 1, int(floor(lum * float(COLOR_AMOUNT))))];
}


vec3 quantize(vec3 col) {
  float luminosity = (col.x + col.y + col.z) / 3.0;
  luminosity = floor(luminosity * float(COLOR_AMOUNT)) / float(COLOR_AMOUNT);
  return vec3(map_colors(luminosity));
}


// I'm too dumb to do shaders, so thanks to GhSoares for this function
// https://godotshaders.com/shader/bloom-post-processing-for-viewports/
vec3 get_bloom_pixel(sampler2D tex, vec2 uv, vec2 tex_pixel_size) {
  vec2 uv2 = floor(uv / tex_pixel_size) * tex_pixel_size;
  uv2 += tex_pixel_size * .001;
  vec3 tl = max(quantize(texture(tex, uv2).rgb) - bloom_threshold, 0.0);
  vec3 tr = max(quantize(texture(tex, uv2 + vec2(tex_pixel_size.x, 0.0)).rgb) - bloom_threshold, 0.0);
  vec3 bl = max(quantize(texture(tex, uv2 + vec2(0.0, tex_pixel_size.y)).rgb) - bloom_threshold, 0.0);
  vec3 br = max(quantize(texture(tex, uv2 + vec2(tex_pixel_size.x, tex_pixel_size.y)).rgb) - bloom_threshold, 0.0);
  vec2 f = fract( uv / tex_pixel_size );

  vec3 tA = mix( tl, tr, f.x );
  vec3 tB = mix( bl, br, f.x );

  return mix( tA, tB, f.y );
}

// I'm too dumb to do shaders, so thanks to GhSoares for this function
// https://godotshaders.com/shader/bloom-post-processing-for-viewports/
vec3 get_bloom(sampler2D tex, vec2 uv, vec2 tex_pixel_size) {
  vec3 bloom = vec3(0.0);
  vec2 off = vec2(1) * tex_pixel_size * bloom_radius;
  bloom += get_bloom_pixel(tex, uv + off * vec2(-1, -1), tex_pixel_size * bloom_radius) * 0.292893;
  bloom += get_bloom_pixel(tex, uv + off * vec2(-1, 0), tex_pixel_size * bloom_radius) * 0.5;
  bloom += get_bloom_pixel(tex, uv + off * vec2(-1, 1), tex_pixel_size * bloom_radius) * 0.292893;
  bloom += get_bloom_pixel(tex, uv + off * vec2(0, -1), tex_pixel_size * bloom_radius) * 0.5;
  bloom += get_bloom_pixel(tex, uv + off * vec2(0, 0), tex_pixel_size * bloom_radius) * 1.0;
  bloom += get_bloom_pixel(tex, uv + off * vec2(0, 1), tex_pixel_size * bloom_radius) * 0.5;
  bloom += get_bloom_pixel(tex, uv + off * vec2(1, -1), tex_pixel_size * bloom_radius) * 0.292893;
  bloom += get_bloom_pixel(tex, uv + off * vec2(1, 0), tex_pixel_size * bloom_radius) * 0.5;
  bloom += get_bloom_pixel(tex, uv + off * vec2(1, 1), tex_pixel_size * bloom_radius) * 0.292893;
  bloom /= 4.171573f;
  return bloom;
}


void fragment() {
  vec2 warped_coords = warp(UV, aspect, curve);
    vec4 col = texture(screen_texture, warped_coords);
    vec3 bloom = get_bloom(screen_texture, warped_coords, SCREEN_PIXEL_SIZE);
    col.xyz = quantize(col.xyz);
    col.xyz += bloom * bloom_intensity;
    
    COLOR = col;
}
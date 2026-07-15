shader_type canvas_item;

const int COLOR_AMOUNT = 4;

uniform float bloom_radius = 1.0;
uniform float bloom_threshold : hint_range(0.0, 1.0) = 0.7; 
uniform float bloom_intensity = 1.0;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;
uniform vec3 color_map[COLOR_AMOUNT] : source_color;

uniform float aspect : hint_range(0.5, 1.0) = 0.75;
uniform float curve : hint_range(0.0, 0.5) = 0.0;

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

vec3 quantize_and_map(vec3 col) {
  float lum = dot(col, vec3(0.2126, 0.7152, 0.0722));
  int index = int(clamp(floor(lum * float(COLOR_AMOUNT)), 0.0, float(COLOR_AMOUNT - 1)));
  return color_map[index];
}

vec3 threshold_color(vec3 col, float threshold) {
  float lum = dot(col, vec3(0.2126, 0.7152, 0.0722));
  return col * max(lum - threshold, 0.0);
}

vec3 get_bloom_sample(sampler2D tex, vec2 uv) {
  vec2 clamped_uv = clamp(uv, vec2(0.0), vec2(1.0));
  vec3 base_col = texture(tex, clamped_uv).rgb;
  vec3 mapped_col = quantize_and_map(base_col);
  return threshold_color(mapped_col, bloom_threshold);
}

vec3 get_bloom_pixel(sampler2D tex, vec2 uv, vec2 sample_step) {
  vec2 clamped_uv = clamp(uv, vec2(0.0), vec2(1.0));
  vec2 uv2 = floor(clamped_uv / sample_step) * sample_step;
  uv2 += sample_step * 0.001;

  vec3 tl = get_bloom_sample(tex, uv2);
  vec3 tr = get_bloom_sample(tex, uv2 + vec2(sample_step.x, 0.0));
  vec3 bl = get_bloom_sample(tex, uv2 + vec2(0.0, sample_step.y));
  vec3 br = get_bloom_sample(tex, uv2 + vec2(sample_step.x, sample_step.y));

  vec2 f = fract(clamped_uv / sample_step);
  vec3 tA = mix(tl, tr, f.x);
  vec3 tB = mix(bl, br, f.x);
  return mix(tA, tB, f.y);
}

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

vec4 like_fragment(vec2 uv, vec2 p_size) {
  vec2 warped_coords = warp(uv, aspect, curve);
  if (warped_coords.x < 0.0 || warped_coords.x > 1.0 || warped_coords.y < 0.0 || warped_coords.y > 1.0) {
    return vec4(color_map[0], 1.0);
  }
  vec4 col = texture(screen_texture, warped_coords);
  vec3 final_palette_color = quantize_and_map(col.rgb);
  vec3 bloom = get_bloom(screen_texture, warped_coords, p_size);
  vec3 final_color = clamp(final_palette_color + (bloom * bloom_intensity), vec3(0.0), vec3(1.0));
  return vec4(final_color, 1.0);
}

void fragment() {
  COLOR = like_fragment(UV, SCREEN_PIXEL_SIZE);
}
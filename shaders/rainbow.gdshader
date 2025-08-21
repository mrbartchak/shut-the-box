shader_type canvas_item;

uniform float speed = 1.0;
uniform float scale = 0.2;
uniform float edge_softness = 2.0;
uniform float border_black_thresh = 0.04;
uniform float border_alpha_thresh = 0.9;
uniform bool use_gradient = false;
uniform sampler2D gradient_tex;


vec3 hsv2rgb(vec3 c){
    vec3 p = abs(fract(c.xxx + vec3(0.0, 1.0/3.0, 2.0/3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void fragment(){
    vec4 src = texture(TEXTURE, UV);
    float a = src.a;

    // Check if pixel is dark and opaque
    float luma = dot(src.rgb, vec3(0.2126, 0.7152, 0.0722));
    float is_border = step(luma, border_black_thresh) * step(border_alpha_thresh, a);

    // Check if pixel is part of the sprite and not border
    float in_sprite = step(0.001, a);
    float interior = in_sprite * (1.0 - is_border);

    // Soften edges
    float interior_soft = smoothstep(0.0, edge_softness, interior);

    // Animated rainbow
    float t = TIME * speed;
    float u = fract((UV.x + UV.y) * scale + t);
    vec3 rainbow = use_gradient
        ? texture(gradient_tex, vec2(u, 0.5)).rgb
        : hsv2rgb(vec3(u, 1.0, 1.0));

    // Mix: keep border & outside as-is; fill interior with rainbow
    vec3 rgb = mix(src.rgb, rainbow, interior_soft);

    // Preserve original alpha so outside stays transparent and border remains crisp
    COLOR = vec4(rgb, a);
}

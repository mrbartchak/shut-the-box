shader_type canvas_item;

uniform float amplitude_px : hint_range(0.0, 6.0) = 2.0;
uniform float period_s : hint_range(0.5, 8.0) = 3.0;
uniform float tilt_amount : hint_range(0.0, 4.0) = 1.0;

void vertex() {
    float t = TIME;
    float phase = (6.2831853 / period_s) * t;
    // vertical bob
    VERTEX.y -= sin(phase) * amplitude_px;
    // mild horizontal skew based on y for a “tilt” feel
    VERTEX.x += sin(phase * 0.5) * tilt_amount * (VERTEX.y / 256.0);
}

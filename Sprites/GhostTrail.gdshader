shader_type canvas_item;

uniform float fade_amount : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    COLOR.a *= fade_amount;
}


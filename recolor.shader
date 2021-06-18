shader_type canvas_item; //shader code

uniform vec4 old_color : hint_color;
uniform vec4 old_color2 : hint_color;
uniform vec4 old_color3 : hint_color;
const vec4 thresholdrange = vec4(0.001, 0.001, 0.001, 1);

uniform vec4 new_color : hint_color;

bool bababooey(vec4 input, vec4 target)
{
	return input.r + thresholdrange.r >= target.r && input.r - thresholdrange.r <= target.r
	&& input.g + thresholdrange.g >= target.g && input.g - thresholdrange.g <= target.g
	&& input.b + thresholdrange.b >= target.b && input.b - thresholdrange.b <= target.b;
}

void fragment()
{
    vec4 col = texture(TEXTURE, UV);

    if (bababooey(col, old_color))
    {
    	COLOR = new_color;
    }
	else if(bababooey(col, old_color2))
	{
		COLOR = new_color + (old_color2 - old_color);
	}
	else if(bababooey(col, old_color3))
	{
		COLOR = new_color + (old_color3 - old_color);
	}
	else COLOR = col;
}
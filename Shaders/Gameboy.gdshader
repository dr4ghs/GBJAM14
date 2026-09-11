shader_type canvas_item;

//colour variables that make the palette, these can be changed in the inspector or through code if you want a palette toggle mid-game
//these are RAW values
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform vec3 colour0 : source_color = vec3(0.608, 0.737, 0.059); // lightest
uniform vec3 colour1 : source_color = vec3(0.545, 0.675, 0.059);
uniform vec3 colour2 : source_color = vec3(0.188, 0.384, 0.188);
uniform vec3 colour3 : source_color = vec3(0.059, 0.22, 0.059); // darkest

//code for snapping the screen to four colour values
void fragment() {
    vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV);
        // Snap visible pixels to pallete

		// gray is a weighted value, between 0 and 1 0 being darkest and 1 being lightest, used to show how the human eye perceives 'brightness' in colour on modern monitors, this is quite complicated and I dont fully understand it myself, I just use it to get better results. You can use float gray = max(max(col.r, col.g), col.b); for HSV if you want, but the results are less clean and accurate.
        float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

		//check how intense the brightness is with our defined gray value and snap pixels to the appropriate colour
		if (gray < 0.25) {
            col.rgb = colour3;
        } else if (gray < 0.5) {
            col.rgb = colour2;
        } else if (gray < 0.75) {
            col.rgb = colour1;
        } else {
            col.rgb = colour0;
        }
        COLOR = vec4(col.rgb, col.a);
}
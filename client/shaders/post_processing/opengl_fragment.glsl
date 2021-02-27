uniform sampler2D baseTexture;

void main(void)
{
	vec2 screen = gl_TexCoord[0].st;
	vec4 color = texture2D(baseTexture, screen).rgba;
	// Do any post-processing here
	// Example: grayscale image
	// float gray = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
	// color.r = color.g = color.b = gray;
	gl_FragColor = color;
}

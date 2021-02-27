uniform sampler2D baseTexture;
float width;
float height;

/* https://64.github.io/tonemapping/#uncharted-2
	Hable's UC2 Tone mapping parameters
	A = 0.22;
	B = 0.30;
	C = 0.10;
	D = 0.20;
	E = 0.01;
	F = 0.30;
	W = 11.2;
	equation used:  ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F
*/

vec3 uncharted2Tonemap(vec3 x)
{
	return ((x * (0.22 * x + 0.03) + 0.002) / (x * (0.22 * x + 0.3) + 0.06)) - 0.03333;
}

vec4 applyToneMapping(vec4 color)
{
	color = vec4(pow(color.rgb, vec3(2.2)), color.a);
	const float gamma = 1.6;
	const float exposureBias = 5.5;
	color.rgb = uncharted2Tonemap(exposureBias * color.rgb);
	// Precalculated white_scale from
	//vec3 whiteScale = 1.0 / uncharted2Tonemap(vec3(W));
	vec3 whiteScale = vec3(1.036015346);
	color.rgb *= whiteScale;
	return vec4(pow(color.rgb, vec3(1.0 / gamma)), color.a);
}

/*
void kernel(inout vec4 n[9], sampler2D tex, vec2 coord)
{
	float w = 1.0 / width;
	float h = 1.0 / height;
	n[0] = texture2D(tex, coord + vec2( -w,  -h));
	n[1] = texture2D(tex, coord + vec2(0.0,  -h));
	n[2] = texture2D(tex, coord + vec2(  w,  -h));
	n[3] = texture2D(tex, coord + vec2( -w, 0.0));
	n[4] = texture2D(tex, coord                 );
	n[5] = texture2D(tex, coord + vec2(  w, 0.0));
	n[6] = texture2D(tex, coord + vec2( -w,   h));
	n[7] = texture2D(tex, coord + vec2(0.0,   h));
	n[8] = texture2D(tex, coord + vec2(  w,   h));
}
*/
void main(void)
{
	// ivec2 screen_size = textureSize(baseTexture, 0);
	// ivec2 screen_size = ivec2(1281, 721);
	// width = float(screen_size.x);
	// height = float(screen_size.y);
	vec2 screen = gl_TexCoord[0].st;
	vec4 color = texture2D(baseTexture, screen);
	if (screen.x < 0.5)
		color = applyToneMapping(color);
	gl_FragColor = color;

	// https://lospec.com/palette-list/color-graphics-adapter
	// Minetest, but running on CGA 16-colour palette
	// vec3[16] palette;
	// palette[ 0] = vec3(  0.0 / 255.0,   0.0 / 255.0,   0.0 / 255.0);
	// palette[ 1] = vec3( 85.0 / 255.0,  85.0 / 255.0,  85.0 / 255.0);
	// palette[ 2] = vec3(170.0 / 255.0, 170.0 / 255.0, 170.0 / 255.0);
	// palette[ 3] = vec3(255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
	// palette[ 4] = vec3(  0.0 / 255.0,   0.0 / 255.0, 170.0 / 255.0);
	// palette[ 5] = vec3( 85.0 / 255.0,  85.0 / 255.0, 255.0 / 255.0);
	// palette[ 6] = vec3(  0.0 / 255.0, 170.0 / 255.0,   0.0 / 255.0);
	// palette[ 7] = vec3( 85.0 / 255.0, 255.0 / 255.0,  85.0 / 255.0);
	// palette[ 8] = vec3(  0.0 / 255.0, 170.0 / 255.0, 170.0 / 255.0);
	// palette[ 9] = vec3( 85.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0);
	// palette[10] = vec3(170.0 / 255.0,   0.0 / 255.0,   0.0 / 255.0);
	// palette[11] = vec3(255.0 / 255.0,  85.0 / 255.0,  85.0 / 255.0);
	// palette[12] = vec3(170.0 / 255.0,   0.0 / 255.0, 170.0 / 255.0);
	// palette[13] = vec3(255.0 / 255.0,  85.0 / 255.0, 255.0 / 255.0);
	// palette[14] = vec3(170.0 / 255.0,  85.0 / 255.0,   0.0 / 255.0);
	// palette[15] = vec3(255.0 / 255.0, 255.0 / 255.0,  85.0 / 255.0);

	// https://lospec.com/palette-list/citrink
	// vec3[8] palette;
	// palette[0] = vec3(0xff / 255.0, 0xff / 255.0, 0xff / 255.0);
	// palette[1] = vec3(0xfc / 255.0, 0xf6 / 255.0, 0x60 / 255.0);
	// palette[2] = vec3(0xb2 / 255.0, 0xd9 / 255.0, 0x42 / 255.0);
	// palette[3] = vec3(0x52 / 255.0, 0xc3 / 255.0, 0x3f / 255.0);
	// palette[4] = vec3(0x16 / 255.0, 0x6e / 255.0, 0x7a / 255.0);
	// palette[5] = vec3(0x25 / 255.0, 0x4d / 255.0, 0x70 / 255.0);
	// palette[6] = vec3(0x25 / 255.0, 0x24 / 255.0, 0x46 / 255.0);
	// palette[7] = vec3(0x20 / 255.0, 0x15 / 255.0, 0x33 / 255.0);

	// https://lospec.com/palette-list/paper-palette
	// vec3[2] palette;
	// palette[0] = vec3(0x3e / 255.0, 0x3e / 255.0, 0x3e / 255.0);
	// palette[1] = vec3(0xf6 / 255.0, 0xe7 / 255.0, 0xc1 / 255.0);

	// vec3[4] dither;
	// dither[0] = vec3(0.0 / 4.0, 0.0 / 4.0, 0.0 / 4.0);
	// dither[1] = vec3(2.0 / 4.0, 2.0 / 4.0, 2.0 / 4.0);
	// dither[2] = vec3(3.0 / 4.0, 3.0 / 4.0, 3.0 / 4.0);
	// dither[3] = vec3(1.0 / 4.0, 1.0 / 4.0, 1.0 / 4.0);

	// int bestIndex = 0;
	// float bestDist = 16777216.0;
	// vec4 baseColor = texture2D(baseTexture, screen);
	// ivec2 pixel_pos = ivec2(screen.x * 1280, screen.y * 720);
	// vec3 dither_colour = dither[int(mod(pixel_pos.x, 2)) + 2 * int(mod(pixel_pos.y, 2))];
	// dither_colour -= 0.5;
	// dither_colour /= 4.0;
	// baseColor.rgb += dither_colour;
	// for (int ii = 0; ii < 8; ii ++) {
	// 	float dist = distance(baseColor.rgb, palette[ii]);
	// 	if (dist < bestDist) {
	// 		bestIndex = ii;
	// 		bestDist = dist;
	// 	}
	// }
	// gl_FragColor = vec4(palette[bestIndex], 1.0);

	// vec4 n[9];
	// kernel(n, baseTexture, screen);
	// vec4 sobel_x = n[0] + (2.0 * n[1]) + n[2] - (n[6] + (2.0 * n[7]) + n[8]);
	// vec4 sobel_y = n[2] + (2.0 * n[5]) + n[8] - (n[0] + (2.0 * n[3]) + n[6]);
	// vec4 sobel = sqrt((sobel_x * sobel_x) + (sobel_y * sobel_y));
	// float gray = 0.2126 * sobel.r + 0.7152 * sobel.g + 0.0722 * sobel.b;
	// sobel.r = sobel.g = sobel.b = gray;
	// gl_FragColor = n[4] * vec4(1.0 - sobel.rgb, 1.0);
	// gl_FragColor = vec4(sobel.rgb, 1.0);

	// vec4 color = texture2D(baseTexture, screen).rgba;
	// float gray = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
	// color.r = color.g = color.b = gray;
	// gl_FragColor = color;
}

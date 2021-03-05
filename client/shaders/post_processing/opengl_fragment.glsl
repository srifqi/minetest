// Note: Older (commented) shadings has been removed, see older commits for older shadings

uniform sampler2D baseTexture;
float width;
float height;

void main(void)
{
	mat3 T;
	T[0] = vec3(0.31399022, 0.15537241, 0.01775239);
	T[1] = vec3(0.63951294, 0.75789446, 0.10944209);
	T[2] = vec3(0.04649755, 0.08670142, 0.87256922);
	mat3 Tinv;
	Tinv[0] = vec3( 5.47221206, -1.1252419,   0.02980165);
	Tinv[1] = vec3(-4.6419601,   2.29317094, -0.19318073);
	Tinv[2] = vec3( 0.16963708, -0.1678952,   1.16364789);
	mat3 Sp; // Protanopia
	Sp[0] = vec3(0.0, 0.0, 0.0);
	Sp[1] = vec3(1.05118294, 1.0, 0.0);
	Sp[2] = vec3(-0.05116099, 0.0, 1.0);
	mat3 Sd; // Deuteranopia
	Sd[0] = vec3(1.0, 0.9513092, 0.0);
	Sd[1] = vec3(0.0, 0.0, 0.0);
	Sd[2] = vec3(0.0, 0.04866992, 1.0);
	mat3 St; // Tritanopia
	St[0] = vec3(1.0, 0.0, -0.86744736);
	St[1] = vec3(0.0, 1.0, 1.86727089);
	St[2] = vec3(0.0, 0.0, 0.0);

	vec2 screen = gl_TexCoord[0].st;
	vec4 color = texture2D(baseTexture, screen).rgba;
	// vec3 crgb = color.rgb;
	// vec3 srgb = Tinv * Sp * T * crgb;
	// vec3 srgb = Tinv * Sd * T * crgb;
	// vec3 srgb = Tinv * St * T * crgb;
	// gl_FragColor = vec4(srgb, 1.0);
	gl_FragColor = color;
}

uniform sampler2D texture;
uniform float time;

float help(float k) {
    float amount = 0.;	
	amount = (1. + sin(k * 6.)) * .5;
	amount *= 1. + sin(k * 16.) * .5;
	amount *= 1. + sin(k * 19.) * .5;
	amount *= 1. + sin(k * 27.) * .5;
	amount = pow(amount, 3.);
    return amount;
}

vec3 chromab(vec2 uv) {
    float amount = help(time) * .05;

    vec3 c = vec3(
        texture2D(texture, vec2(uv.x + amount, uv.y)).r,
        texture2D(texture, uv).g,
        texture2D(texture, vec2(uv.x - amount, uv.y)).b
    );

    c *= (1. - amount * .5);

    return c;
}

void main()
{
    vec2 uv = gl_TexCoord[0].xy;
    float shift = sin(uv.y * help(time * .193) * 15.);
    vec2 st = uv + vec2(.03 * (floor(shift * 3.) / 3.), 0.);
    vec3 c = texture2D(texture, st).rgb;

    uv *= 1. - uv.yx;
    float vig = pow(uv.x * uv.y * 15., .6);
    c *= .2 + .8 * vig;

    gl_FragColor = vec4(c, 1.);
}

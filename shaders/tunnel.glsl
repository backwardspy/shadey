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
    vec2 uv = -1. + 2. * gl_TexCoord[0].xy;

    float stime = help(time / 5. - .173) * .09;
    float ctime = help(time / 5. - .852 + 3.14159265 / 2.) * .05;
    uv += vec2(stime, ctime);
    float r = length(uv);
    float t = atan(uv.y, uv.x) + cos(time);
    r += .05 * sin(2. * t);
    vec2 st = vec2(t / 6.28318530, time + (.55 + .45 * sin(time)) / r);

    vec3 c = chromab(st);
    c *= pow(r, .5);

    gl_FragColor = vec4(c, 1);
}

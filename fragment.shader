uniform vec2 iResolution;
uniform float iTime;
vec2 fragCoord = gl_FragCoord.xy;

float phase(float x) {
    return x * 2.0 + iTime * 3.0;
}
float func(float x)
{
    return sin(phase(x)) * 0.5;
}

void main()
{
    vec2 uv = fragCoord/iResolution.xy;
    uv = uv * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y;
    
    const float dx = 0.01;
    float amp = func(uv.x);
    float amp_left = func(uv.x - dx);
    float amp_right = func(uv.x + dx);
    float dy_dx = (amp_right - amp_left) / (dx * 2.0);
    float diff = abs(amp - uv.y);
    diff = mod(diff + 0.25, 0.5) - 0.25;
    diff /= sqrt(dy_dx * dy_dx + 1.0);
    
    vec3 col = vec3(exp(0.2 - diff * 30.0));
    col *= 0.5 + 0.5 * sin(vec3(0.0, 2.0 * 3.14159 / 3.0, 2.0 * 3.14159 * 4.0 / 3.0) + phase(uv.x) - iTime * 5.0);
    col = mix(col, vec3(1.0), exp(0.1 - diff * 100.0));
    col = pow(col, vec3(1.0 / 2.2));
    
    gl_FragColor = vec4(col, 1.0);
}

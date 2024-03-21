uniform vec2 iResolution;
uniform float Time;
vec2 fragCoord = gl_FragCoord.xy;

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5 * cos(Time + vec3(uv.x, uv.y, Time));

    // Output to screen
    gl_FragColor = vec4(col, 1.0);
}

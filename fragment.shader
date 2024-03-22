// Thank you Fabrice Neyret for your advice!
uniform vec2 iResolution; // Разрешение экрана
uniform float iTime; // Время в секундах

mat2 rotation2d(float angle) {
  float s = sin(angle);
  float c = cos(angle);

  return mat2(
    c, -s,
    s, c
  );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = ( fragCoord - .5 * iResolution ) / iResolution.y;
    
    float x = 1e20;
    float y = -1.0;
    int th = 8;
    for (int i=0;i<th;i++) {
        float yes = float(i)/float(th);
        
        vec2 fs = rotation2d(yes*3.1415*2.0) * uv;
        fs = fs-vec2(0.0,0.11);
        float test = length(fs*30.0);
        if (test < 1.0) { y = yes; }
        x = min(x,test);
    }
    
    float bgshade = 0.1;
    y = 1.0-y;
    uv.y += 0.99;
    
    float flippy = mix(bgshade*0.9+0.1,1.0,fract(y-iTime));
    float pxw = 45./iResolution.y;
    if (y >= -1.0) { flippy = mix(flippy,bgshade,smoothstep(1.0-pxw,1.0,x)); }
    else { flippy = bgshade; }
    
    fragColor = vec4(vec3(flippy),1.0);
}


void main() {
    vec4 color;
    mainImage(color, gl_FragCoord.xy);
    gl_FragColor = color;
}

///////////////////////////////////////////////////////////////////////
////////////////////////////[NOISE]////////////////////////////////////

#define vec2 float2
#define vec3 float3
#define vec4 float4

#define NOISE_1(v2) noise1(v2)
#define NOISE_2(v2) noise2(v2)
#define NOISE_3(v2) noise3(v2)

//[RANDOM]
///////////////////////////////////////////////////////////////////////
float random (in vec2 st) {
    return frac(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}
//-----------------------------------------------------------------
vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*frac(sin(st)*43758.5453123);
}
///////////////////////////////////////////////////////////////////////



//[NOISE 1]
///////////////////////////////////////////////////////////////////////
float noise1 (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = frac(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return lerp(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}
///////////////////////////////////////////////////////////////////////



//[NOISE 2]
///////////////////////////////////////////////////////////////////////
float noise2(vec2 st) {
    vec2 i = floor(st);
    vec2 f = frac(st);
    vec2 u = f*f*(3.0-2.0*f);
    float v = lerp( lerp( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     	 dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                   lerp( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     	 dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
    return saturate(v);
}
///////////////////////////////////////////////////////////////////////



//[NOISE 3]
///////////////////////////////////////////////////////////////////////
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }
float noise3(vec2 v) {
    const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v - i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y)? vec2(1.0, 0.0):vec2(0.0, 1.0);
    vec2 x1 = x0.xy + C.xx - i1;
    vec2 x2 = x0.xy + C.zz;
    i = mod289(i);
    vec3 p = permute(permute( i.y + vec3(0.0, i1.y, 1.0))+ i.x + vec3(0.0, i1.x, 1.0 ));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x1,x1), dot(x2,x2)), 0.0);
    m = m*m ;m = m*m ;
    vec3 x = 2.0 * frac(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0+h*h);
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * vec2(x1.x,x2.x) + h.yz * vec2(x1.y,x2.y);
    return saturate(130.0 * dot(m, g));
}
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

// 以下算法取自
// 原文：https://blog.csdn.net/lynon/article/details/78957106

//参考:
//算法详解：candycat-【图形学】谈谈噪声 - https://blog.csdn.net/candycat1992/article/details/50346469 
//WIKI - https://en.wikipedia.org/wiki/Simplex_noise
//glsl noise algorithms ，各种噪音算法 - https://blog.csdn.net/lynon/article/details/78957106


#define vec2 float2
#define vec3 float3
#define vec4 float4
#define mix lerp
#define fract frac

float rand(float n)
{
    return fract(sin(n) * 43758.5453123);
}

float rand2(vec2 n) 
{ 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}
 
float noise1 (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = frac(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return lerp(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}
 
float noise2(vec2 p)
{
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);
 
    float res = mix(
        mix(rand2(ip),rand2(ip+vec2(1.0,0.0)),u.x),
        mix(rand2(ip+vec2(0.0,1.0)),rand2(ip+vec2(1.0,1.0)),u.x),u.y);
    return res*res;
}

// Simplex 2D noise
// https://blog.csdn.net/lynon/article/details/78957106
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }
 
float noise3(vec2 v){
    const vec4 C = vec4(0.211324865405187, 0.366025403784439,
            -0.577350269189626, 0.024390243902439);
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod289(i);
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
    + i.x + vec3(0.0, i1.x, 1.0 ));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
    m = m*m ;
    m = m*m ;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}


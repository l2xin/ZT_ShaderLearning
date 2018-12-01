
//参考
//算法详解：candycat-【图形学】谈谈噪声 - https://blog.csdn.net/candycat1992/article/details/50346469 
//WIKI - https://en.wikipedia.org/wiki/Simplex_noise
//glsl noise algorithms ，各种噪音算法 - https://blog.csdn.net/lynon/article/details/78957106


float2 hash22(float2 p)
{
    p = float2(dot(p, float2(127.1, 311.7)),
        dot(p, float2(269.5, 183.3)));

    return -1.0 + 2.0 * frac( sin(p) * 43758.5453123);
}

float noise(float2 p)
{
    float2 i = floor(p.xy);
    float2 f = frac(p.xy);

    // Ease Curve  
    //vec2 u = f*f*(3.0-2.0*f);  
    float2 u = f*f*f*(6.0*f*f - 15.0*f + 10.0);

    return lerp(lerp(dot(hash22(i + float2(0.0, 0.0)), f - float2(0.0, 0.0)),
        dot(hash22(i + float2(1.0, 0.0)), f - float2(1.0, 0.0)), u.x),
        lerp(dot(hash22(i + float2(0.0, 1.0)), f - float2(0.0, 1.0)),
            dot(hash22(i + float2(1.0, 1.0)), f - float2(1.0, 1.0)), u.x), u.y);
}


float noise_fractal(float2 p)
{
    p *= 5.0;
    float2x2 m = float2x2(1.6, 1.2, -1.2, 1.6);
    float f = 0.5000 * noise(p); 
    p = mul(m,p);
    f += 0.2500*noise(p); 
    p = mul(m, p);
    f += 0.1250*noise(p); 
    p = mul(m, p);
    f += 0.0625*noise(p); 
    p = mul(m, p);

    return f;
}


float noise_sum_abs(float2 p)
{
    float f = 0.0;
    p = p * 7.0;
    f += 1.0000 * abs(noise(p)); p = 2.0 * p;
    f += 0.5000 * abs(noise(p)); p = 2.0 * p;
    f += 0.2500 * abs(noise(p)); p = 2.0 * p;
    f += 0.1250 * abs(noise(p)); p = 2.0 * p;
    f += 0.0625 * abs(noise(p)); p = 2.0 * p;

    return f;
}

float hash21(float2 p)
{
    return frac(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
    //vec3 p3  = fract(vec3(p.xyx) * .1931);  
    //p3 += dot(p3, p3.yzx + 19.19);  
    //return fract((p3.x + p3.y) * p3.z);  
}

float value_noise(float2 p)
{
    p *= 56.0;
    float2 pi = floor(p);
    //vec2 pf = p - pi;  
    float2 pf = frac(p);

    float2 w = pf * pf * (3.0 - 2.0 * pf);

    // 它把原来的梯度替换成了一个简单的伪随机值，我们也不需要进行点乘操作，  
    // 而直接把晶格顶点处的随机值按权重相加即可。  
    float v = lerp(lerp(hash21(pi + float2(0.0, 0.0)), hash21(pi + float2(1.0, 0.0)), w.x),
        lerp(hash21(pi + float2(0.0, 1.0)), hash21(pi + float2(1.0, 1.0)), w.x),
        w.y);
    return saturate(v);
}

float simplex_noise(float2 p)
{
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;  
    const float K2 = 0.211324865; // (3-sqrt(3))/6;  
                                    // 变换到新网格的(0, 0)点  
    float2 i = floor(p + (p.x + p.y) * K1);
    // i - (i.x+i.y)*K2换算到旧网格点  
    // a:变形前输入点p到该网格点的距离  
    float2 a = p - (i - (i.x + i.y) * K2);
    float2 o = (a.x < a.y) ? float2(0.0, 1.0) : float2(1.0, 0.0);
    // 新网格(1.0, 0.0)或(0.0, 1.0)  
    // b = p - (i+o - (i.x + i.y + 1.0)*K2);  
    float2 b = a - o + K2;
    // 新网格(1.0, 1.0)  
    // c = p - (i+vec2(1.0, 1.0) - (i.x+1.0 + i.y+1.0)*K2);  
    float2 c = a - 1.0 + 2.0 * K2;
    // 计算每个顶点的权重向量，r^2 = 0.5  
    float2 h = max(0.5 - float3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
    // 每个顶点的梯度向量和距离向量的点乘，然后再乘上权重向量  
    float2 n = h * h * h * h * float3(dot(a, hash22(i)), dot(b, hash22(i + o)), dot(c, hash22(i + 1.0)));

    // 之所以乘上70，是在计算了n每个分量的和的最大值以后得出的，这样才能保证将n各个分量相加以后的结果在[-1, 1]之间  
    return dot(float3(70.0, 70.0, 70.0), n);
}

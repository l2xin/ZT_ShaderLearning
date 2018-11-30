/**
 * 控制模型顶点以随机方式缩放位移
 * @author l2xin
 */
Shader "Custom/T_VertexControlByNoise"
{
	Properties
	{
		_MaxMoveDistance("MaxMoveDistance", Range(1,5)) = 2	//最大移动距离
		_NoiseSpeed("NoiseSpeed", Range(0,10)) = 1
		_NoiseScale("NoiseScale", Range(0, 1)) = 0.2

		[KeywordEnum(Noise 1, Noise 2, Noise 3, Noise 4)]_NoiseType("NoiseType", float) = 0

		_FrontColor("FrontColor", Color) = (0,1,1,0)
		_BackColor("BackColor", Color) = (1,0,0,0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Cull Off


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature _NOISETYPE_NOISE_1 _NOISETYPE_NOISE_2 _NOISETYPE_NOISE_3 _NOISETYPE_NOISE_4

			

			#pragma target 3.0

			
			#include "UnityCG.cginc"
			#include "CandycatNoise.cginc"
			//#include "MyNoise.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 diffuseFront : TEXCOORD1;
				float4 diffuseBack : TEXCOORD2;
			};

			float _MaxMoveDistance;
			float _NoiseSpeed;
			float _NoiseScale;
			float4 _FrontColor;
			float4 _BackColor;


			//计算a在b上的投影
			float3 Proj(float3 a, float3 b)
			{
				return (dot(a, b)/ dot(b,b)) * b;
			}

			//计算切线方向
			float3 Reject(float3 a, float3 b)
			{
				return a - Proj(a, b);
			}
			
			v2f vert (a2v v)
			{
				v2f o;


				float2 randInput = v.normal * _NoiseScale + (_NoiseSpeed * _Time.x);

				#if _NOISETYPE_NOISE_1
				float randResult = noise1(randInput);
				#elif _NOISETYPE_NOISE_2
				float randResult = noise2(randInput);
				#elif _NOISETYPE_NOISE_3
				float randResult = noise3(randInput);
				#elif _NOISETYPE_NOISE_4
				float randResult = noise4(randInput);
				#endif

				v.vertex.xyz += randResult * _MaxMoveDistance * v.normal;
				float3 vertex = Proj(v.vertex, v.normal) + Reject(v.vertex, v.normal) * (1-randResult);
				o.vertex = UnityObjectToClipPos(vertex);


				//逐顶点光照
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 vertexLightColor = dot( worldNormal, _WorldSpaceLightPos0.xyz);

				o.diffuseFront = _FrontColor * (vertexLightColor.r * 0.5 + 0.5);
				o.diffuseBack = _BackColor * (-vertexLightColor.g * 0.5 + 0.5);

				return o;
			}
			
			fixed4 frag (v2f i, float vfaceValue:VFACE) : SV_Target
			{	
				fixed4 col = vfaceValue > 0 ?  i.diffuseFront : i.diffuseBack;
				return col;
			}
			ENDCG
		}
	}
}

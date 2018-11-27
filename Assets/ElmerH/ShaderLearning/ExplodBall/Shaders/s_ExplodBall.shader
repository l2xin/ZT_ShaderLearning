Shader "JPLearning/ElmerH/ExplodBall"
{
	Properties
	{
		[Header(PARAMTER________________________________________)]
		_VerOffset("Vertex Offset", Range(0, 2)) = 0

		[KeywordEnum(Noise 1, Noise 2, Noise 3)]_NoiseType("Noise Type", Float) = 0
		_NoiseSpeed("Noise Speed", Range(0, 25)) = 1
		_NoiseScale("Noise Scale", Range(0, 1)) = 0.1

		[Header(COLOR___________________________________________)]
		_FrontCol("Front Color", Color) = (1,0,0,0)
		_BackCol("Back Color", Color) = (0,1,1,0)
	}
	SubShader
	{
		Pass
		{
			Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
			Cull Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma shader_feature  _NOISETYPE_NOISE_1 _NOISETYPE_NOISE_2 _NOISETYPE_NOISE_3

			#include "UnityCG.cginc"
			#include "MyNoise.cginc"

			struct a2v
			{
				float4 vertex 	: POSITION;
				float3 normal 	: NORMAL;
				float2 uv 		: TEXCOORD01;
			};

			struct v2f
			{
				float4 vertex 	: SV_POSITION;
				float2 color 	: COLOR;
			};

			float _VerOffset, _VertScale, _NoiseSpeed, _NoiseScale;
			float4 _FrontCol, _BackCol;
			sampler2D _MainTex;	float4 _MainTex_ST;

			//Transform vertex scale and offset.
			void VertexTransform(inout float3 vertex, float3 normal, float offset, float noise)
			{
				vertex += (normal * offset) * noise;
				float3 vp = dot(normal, vertex)*normal;
				vertex = (vertex - vp) * (1-noise) + vp;
			}

			v2f vert (a2v v)
			{
				v2f o;
				
				//Switch the noise type.
				float2 rand = v.normal * _NoiseScale + ( _Time.x * _NoiseSpeed );
				#if _NOISETYPE_NOISE_1 
				float noise = NOISE_1( rand );
				#elif _NOISETYPE_NOISE_2
				float noise = NOISE_2( rand );
				#else
				float noise = NOISE_3( rand );
				#endif

				//Transform the vertices.
				VertexTransform(v.vertex.xyz, v.normal, _VerOffset, noise);
				o.vertex = UnityObjectToClipPos(v.vertex);

				//Calculate the color value[N dot L].
				half3 normal = normalize(UnityObjectToWorldNormal(v.normal));
				half3 lightDir = normalize(WorldSpaceLightDir(v.vertex));
				o.color.r = max(0, dot( normal, lightDir)*.5+.5);
				o.color.g = max(0, dot(-normal, lightDir)*.5+.5);

 				return o;
			}

			fixed4 frag (v2f i, fixed facing : VFACE) : SV_Target
			{
				fixed4 col = facing > 0 ? _FrontCol*i.color.r : _BackCol*i.color.g;
				return col;
			}
			ENDCG
		}
	}
}

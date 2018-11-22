// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/RoundLog/T_VertexChange"
{

	Properties
	{
		_MainTex("Main Tex", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1, 1, 1, 1)

		_Offset("Offset", float) = 1.0
	}

	SubShader
	{

		Pass 
		{
			Tags {"RenderType"="Opaque"}
			Cull Off
			Blend SrcAlpha OneMinusSrcAlpha	//Normal

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _MainColor;
			fixed _Offset;

			struct a2v {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				float4 normal : NORMAL;
			};

			struct v2f {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(a2v v) {
				v2f o;
				
				v.vertex.xyz += v.normal * (_SinTime.w + 1) * _Offset;

				o.position = UnityObjectToClipPos(v.vertex);

				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				fixed4 c = tex2D(_MainTex, i.uv);

				return fixed4(c.rgb, c.a);
			}

			ENDCG
		}
	}
		FallBack "Diffuse"
}

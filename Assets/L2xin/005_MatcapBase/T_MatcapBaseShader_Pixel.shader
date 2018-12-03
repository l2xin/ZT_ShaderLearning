Shader "JPLearning/L2xin/T_MatcapBaseShader_Pixel"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_MatcapTex ("MatcapTex", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float2 matcapUV : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _MatcapTex;
			float4 _MatcapTex_ST;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, worldNormal);
				o.matcapUV = viewNormal.xy * 0.5 + 0.5;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 matcapColor = tex2D(_MatcapTex, i.matcapUV);
				return col * matcapColor;
			}
			ENDCG
		}
	}
}

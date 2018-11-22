shader "Unlit/Texturing"
{
	Properties
	{
		_MainTex ("Texture", 2D ) = "white"{}
		_Color ("COLOR", COLOR)= (0,0,0, 0)
		_VertexOffset("VertexOffset", float) = 1.0
 	}
	Subshader
	{
		Tags {"RenderTyper" = "Trasparent"}
		LOD 100

		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag
		
			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _VertexOffset;

			
			struct VertexInput
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct VertexOutput
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			
			
			VertexOutput vert (VertexInput v)
			{
				VertexOutput o;
				v.vertex.xyz += v.normal * _VertexOffset * (_SinTime.w + 1);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag (VertexOutput i) : SV_Target
			{
				fixed4 finalDiffuse = tex2D(_MainTex,i.uv);
				return finalDiffuse;
			}
			ENDCG	
		}
	}
	fallback "Diffuse"
}
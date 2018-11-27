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
		Tags {"RenderTyper" = "Opaque"}
		cull off

		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
		
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

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 diffuseFront: DIFFUSE0;
				float4 diffuseBack: DIFFUSE1;
				float4 matcapUV : MATCAPUV;
			};

			
			
			v2f vert (VertexInput v)
			{
				v2f o;
				v.vertex.xyz += v.normal * _VertexOffset * (_CosTime.w + 1);
				o.diffuseFront = max(0, dot( UnityObjectToWorldNormal(v.normal), _WorldSpaceLightPos0.xyz));
				o.diffuseBack = max(0, dot( -UnityObjectToWorldNormal(v.normal), _WorldSpaceLightPos0.xyz));
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag (v2f i, float vfaceValue: VFACE) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col = vfaceValue > 0 ? i.diffuseFront : i.diffuseBack;
				return col * tex2D(_MainTex, i.uv);
			}

			ENDCG	
		}
	}
	fallback "Diffuse"
}
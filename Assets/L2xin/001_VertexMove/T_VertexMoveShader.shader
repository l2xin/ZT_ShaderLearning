/**
 * 控制模型顶点移动
 * @author l2xin
 */
Shader "Custom/T_VertexMoveShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaxDistance("MaxDistance", Range(0.1,1)) = 0.2	//最大移动距离
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

			
			#include "UnityCG.cginc"

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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _MaxDistance;
			
			v2f vert (a2v v)
			{
				v2f o;
				v.vertex.xyz += (_SinTime.w + 1) * _MaxDistance * v.normal.xyz;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}

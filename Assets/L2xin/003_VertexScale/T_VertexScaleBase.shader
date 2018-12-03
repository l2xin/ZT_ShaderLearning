/**
 * 控制模型顶点移动
 * @author l2xin
 */
Shader "JPLearning/L2xin/T_VertexScaleBase"
{
	Properties
	{
		_MaxScale("MaxScale", Range(0,5)) = 1	//最大缩放倍数
		_MaxMoveDistance("MaxMoveDistance", Range(1,5)) = 1	//最大移动距离

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

			#pragma target 3.0

			
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
				float4 diffuseFront : TEXCOORD1;
				float4 diffuseBack : TEXCOORD2;
			};

			float _MaxScale;
			float _MaxMoveDistance;
			float4 _FrontColor;
			float4 _BackColor;
			
			v2f vert (a2v v)
			{
				v2f o;

				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				v.vertex.xyz *= (_SinTime.w + 2) * _MaxScale;
				v.vertex.xyz += 1 * _MaxMoveDistance * worldNormal;

				o.diffuseFront = max(0, dot( worldNormal, _WorldSpaceLightPos0.xyz));
				o.diffuseBack = max(0, dot( -worldNormal, _WorldSpaceLightPos0.xyz));
				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}
			
			fixed4 frag (v2f i, float vfaceValue:VFACE) : SV_Target
			{	
				fixed4 col = vfaceValue > 0 ?  _FrontColor : _BackColor;
				return col;
			}
			ENDCG
		}
	}
}

/**
 * 控制模型沿切线方向缩放
 * @author l2xin
 */
Shader "JPLearning/L2xin/T_VertexScaleTangent"
{
	Properties
	{
		_MaxScale("ScaleSpeed", Range(0,1)) = 1	//缩放比例
		_MaxMoveDistance("MaxMoveDistance", Range(1,50)) = 1	//最大移动距离

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

				//v.vertex.xyz += (_SinTime.w + 1) * _MaxMoveDistance * v.normal;

				//下面这两行效果一样
				// float3 vertex = Proj(v.vertex, v.normal) + Reject(v.vertex, v.normal) * (_SinTime.w + 1) * 0.5;
				float3 vertex = v.vertex - Reject(v.vertex, v.normal) * (_SinTime.w + 1) * 0.5;

				o.diffuseFront = max(0, dot( UnityObjectToWorldNormal(v.normal), _WorldSpaceLightPos0.xyz));
				o.diffuseBack = max(0, dot( -UnityObjectToWorldNormal(v.normal), _WorldSpaceLightPos0.xyz));
				o.vertex = UnityObjectToClipPos(vertex);

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

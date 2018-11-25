/**
 * 双面镜面反射
 * @author l2xin
 */
Shader "Custom/T_DoubleFaceMirrorReflection"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1,1,1,0)
		//顶点偏移 方便观察双面效果
		_VertexOffset("VertexOffset", Range(0,20)) = 0
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
				float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 diffuseFront: DIFFUSE0;
				float4 diffuseBack: DIFFUSE1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _VertexOffset;
			float4 _MainColor;
			
			v2f vert (a2v v)
			{
				v2f o;
				v.vertex.xyz += _VertexOffset * v.normal;
				
				//内置变量参考https://docs.unity3d.com/462/Documentation/Manual/SL-BuiltinValues.html
				//上一级目录下 builtin_shaders-2018.2.11f1/UnityShaderVariables中有_WorldSpaceLightPos0
				o.diffuseFront = max(0, dot( UnityObjectToWorldNormal(v.normal), _WorldSpaceLightPos0.xyz));
				o.diffuseBack = max(0, dot( -UnityObjectToWorldNormal(v.normal), _WorldSpaceLightPos0.xyz));
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			//VFACE 语义代表前后面 需#pragma target 3.0 且Cull Off才有双面效果
			fixed4 frag (v2f i, float vfaceValue: VFACE) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col = vfaceValue > 0 ? i.diffuseFront : i.diffuseBack;
				return col * tex2D(_MainTex, i.uv) * _MainColor;
			}

			ENDCG
		}
	}
}

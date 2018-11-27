Shader "JPLearning/ElmerH/SimpleMatCap"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			
			void vert (inout half4 vertex:POSITION, out half2 uv:TEXCOORD0, half3 normal:NORMAL)
			{
				vertex = UnityObjectToClipPos(vertex);
				uv = mul((half3x3)UNITY_MATRIX_IT_MV, normal).xy *.5 +.5;
			}
			
			fixed4 frag (half4 vertex:SV_POSITION, half2 uv:TEXCOORD0):SV_Target
			{
				fixed4 col = tex2D(_MainTex, uv);
				return col;
			}
			ENDCG
		}
	}
}

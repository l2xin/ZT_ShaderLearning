// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Templates/Unlit"
{
	Properties
	{
		_Color0("Color 0", Color) = (1,1,1,0)
		_Float0("Float 0", Float) = 5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.0
		#pragma only_renderers d3d9 d3d11 glcore gles3 metal d3d11_9x 
		#pragma surface surf Standard keepalpha noshadow nofog vertex:vertexDataFunc 
		struct Input
		{
			float3 worldNormal;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _Color0;
		uniform float _Float0;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float4 transform46 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			v.vertex.xyz += ( transform46 * max( _SinTime.w , 0.0 ) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			o.Albedo = tex2D( _TextureSample0, ase_vertexNormal.xy ).rgb;
			o.Emission = ( _Color0 * _Float0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15900
1937;52;1849;1004;1336.715;881.9054;1;True;False
Node;AmplifyShaderEditor.WorldNormalVector;45;-967.715,-427.9054;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinTimeNode;62;-909.715,-225.9054;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;46;-687.715,-426.9054;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;61;-623.715,-150.9054;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;-703.715,-738.9054;Float;False;Property;_Color0;Color 0;0;0;Create;True;0;0;False;0;1,1,1,0;1,0.1839623,0.1839623,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;-615.715,-531.9054;Float;False;Property;_Float0;Float 0;1;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;58;-908.715,-967.9054;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-361.715,-293.9054;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-314.715,-618.9054;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;53;-457.715,-935.9054;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;131.2309,-619.6028;Float;False;True;4;Float;ASEMaterialInspector;0;0;Standard;Hidden/Templates/Unlit;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;True;True;True;False;True;True;True;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;45;0
WireConnection;61;0;62;4
WireConnection;48;0;46;0
WireConnection;48;1;61;0
WireConnection;49;0;44;0
WireConnection;49;1;50;0
WireConnection;53;1;58;0
WireConnection;1;0;53;0
WireConnection;1;2;49;0
WireConnection;1;11;48;0
ASEEND*/
//CHKSM=26FDDA2D20BCBF130142BA1D3110DDDEDADC8AD9
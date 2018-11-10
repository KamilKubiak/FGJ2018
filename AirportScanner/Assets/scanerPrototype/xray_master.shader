// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "xray_master"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_MetallicGlossMap("_MetallicGlossMap", 2D) = "black" {}
		_BumpMap("_BumpMap", 2D) = "bump" {}
		_OcclusionMap("_OcclusionMap", 2D) = "white" {}
		_speed("speed", Float) = 1
		[Toggle(_ANIMATEDUV_ON)] _AnimatedUv("AnimatedUv", Float) = 0
		_thicknes_mul("thicknes_mul", Range( 0 , 2)) = 1
		_fresnel_mul("fresnel_mul", Range( 0 , 2)) = 0.5
		_XrayColor("_XrayColor", Color) = (0.3081747,0.4343635,0.5588235,0.447)
		_thicknessMap("thicknessMap", 2D) = "white" {}
		_Color("_Color", Color) = (0,0,0,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "Xray"="True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature _ANIMATEDUV_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _XrayColor;
		uniform sampler2D _thicknessMap;
		uniform float _fresnel_mul;
		uniform float _thicknes_mul;
		uniform sampler2D _BumpMap;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform sampler2D _MetallicGlossMap;
		uniform sampler2D _OcclusionMap;

		UNITY_INSTANCING_CBUFFER_START(xray_master)
			UNITY_DEFINE_INSTANCED_PROP(float, _speed)
		UNITY_INSTANCING_CBUFFER_END

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float _speed_Instance = UNITY_ACCESS_INSTANCED_PROP(_speed);
			float mulTime12 = _Time.y * _speed_Instance;
			float2 appendResult10 = (float2(mulTime12 , 0.0));
			#ifdef _ANIMATEDUV_ON
				float2 staticSwitch15 = ( i.uv_texcoord + appendResult10 );
			#else
				float2 staticSwitch15 = i.uv_texcoord;
			#endif
			o.Normal = UnpackNormal( tex2D( _BumpMap, staticSwitch15 ) );
			o.Albedo = ( _Color * tex2D( _MainTex, staticSwitch15 ) ).rgb;
			float4 tex2DNode4 = tex2D( _MetallicGlossMap, staticSwitch15 );
			o.Metallic = tex2DNode4.r;
			o.Smoothness = tex2DNode4.a;
			o.Occlusion = tex2D( _OcclusionMap, staticSwitch15 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15800
52;29;1746;1004;1989.73;360.6712;1.705099;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-1226.291,213.6288;Float;False;InstancedProperty;_speed;speed;5;0;Create;True;0;0;True;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1353.291,51.62878;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;-1144.291,50.62878;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1262.291,-133.3712;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-999.2911,-83.37122;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;15;-833.2911,-6.371216;Float;False;Property;_AnimatedUv;AnimatedUv;6;0;Create;True;0;0;True;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;21;-171.4844,-435.9123;Float;False;Property;_Color;_Color;12;0;Create;True;0;0;False;0;0,0,0,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-562,-343;Float;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;120.5156,-428.9123;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-545.4149,704.9128;Float;False;Property;_fresnel_mul;fresnel_mul;9;0;Create;True;0;0;True;0;0.5;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;16;-915.2911,-193.3712;Float;False;Property;_ToggleSwitch0;Toggle Switch0;7;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-610.9921,825.412;Float;False;Property;_XrayColor;_XrayColor;10;0;Create;True;0;0;True;0;0.3081747,0.4343635,0.5588235,0.447;0.3081747,0.4343635,0.5588235,0.447;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-641.6665,573.0907;Float;False;Property;_thicknes_mul;thicknes_mul;8;0;Create;True;0;0;True;0;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-572,264;Float;True;Property;_OcclusionMap;_OcclusionMap;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-88,-141;Float;False;Property;_Float0;Float 0;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-560,82;Float;True;Property;_MetallicGlossMap;_MetallicGlossMap;1;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-237.8846,441.4613;Float;True;Property;_thicknessMap;thicknessMap;11;0;Create;True;0;0;True;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-557,-158;Float;True;Property;_BumpMap;_BumpMap;2;0;Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;20,-1;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;xray_master;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;1;Xray=True;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;10;0;12;0
WireConnection;14;0;13;0
WireConnection;14;1;10;0
WireConnection;15;1;13;0
WireConnection;15;0;14;0
WireConnection;2;1;15;0
WireConnection;22;0;21;0
WireConnection;22;1;2;0
WireConnection;5;1;15;0
WireConnection;4;1;15;0
WireConnection;3;1;15;0
WireConnection;0;0;22;0
WireConnection;0;1;3;0
WireConnection;0;3;4;1
WireConnection;0;4;4;4
WireConnection;0;5;5;1
ASEEND*/
//CHKSM=D6B4E95CC5A21DE9D1AE729FDF21FC331B804177
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "xray"
{
	Properties
	{
		_thicknessMap("thicknessMap", 2D) = "white" {}
		_XrayColor("_XrayColor", Color) = (0.1458694,0.1744198,0.2794118,0.522)
		_fresnel_mul("fresnel_mul", Range( 0 , 2)) = 0.33
		_thicknes_mul("thicknes_mul", Range( 0 , 2)) = 1
		_fresnel_bias("fresnel_bias", Float) = 0
		_fresnel_scale("fresnel_scale", Float) = 0.8
		_fresnel_power("fresnel_power", Float) = 5.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" "Xray"="True" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest Always
		Offset 0 , 0
		
		

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_OUTPUT_STEREO
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			uniform float _fresnel_bias;
			uniform float _fresnel_scale;
			uniform float _fresnel_power;
			uniform float _fresnel_mul;
			uniform sampler2D _thicknessMap;
			uniform float4 _thicknessMap_ST;
			uniform float _thicknes_mul;
			uniform float4 _XrayColor;
			UNITY_INSTANCING_CBUFFER_START(xray)
			UNITY_INSTANCING_CBUFFER_END
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.zw = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode1 = ( _fresnel_bias + _fresnel_scale * pow( 1.0 - fresnelNdotV1, _fresnel_power ) );
				float2 uv_thicknessMap = i.ase_texcoord2.xy * _thicknessMap_ST.xy + _thicknessMap_ST.zw;
				float temp_output_6_0 = ( ( saturate( fresnelNode1 ) * _fresnel_mul ) + ( tex2D( _thicknessMap, uv_thicknessMap ).r * _thicknes_mul ) );
				float4 appendResult2 = (float4(temp_output_6_0 , temp_output_6_0 , temp_output_6_0 , temp_output_6_0));
				
				
				finalColor = ( appendResult2 * _XrayColor );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback "False"
}
/*ASEBEGIN
Version=15800
94;29;1746;1004;1808.415;450.7081;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;22;-1060.415,172.2919;Float;False;Property;_fresnel_power;fresnel_power;9;0;Create;True;0;0;False;0;5.1;5.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1093.415,106.2919;Float;False;Property;_fresnel_scale;fresnel_scale;8;0;Create;True;0;0;False;0;0.8;5.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1080.415,32.29193;Float;False;Property;_fresnel_bias;fresnel_bias;7;0;Create;True;0;0;False;0;0;5.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-862,21;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.8;False;3;FLOAT;5.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-659.0948,-330.8333;Float;True;Property;_thicknessMap;thicknessMap;0;0;Create;True;0;0;False;0;None;41c67c686a8113c4ba3d197c35236b60;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-607.09,266.0445;Float;False;Property;_fresnel_mul;fresnel_mul;3;0;Create;True;0;0;False;0;0.33;0.33;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-569.7578,-125.7275;Float;False;Property;_thicknes_mul;thicknes_mul;4;0;Create;True;0;0;False;0;1;1.33;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-538.0903,-34.95551;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-331.0903,140.0445;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-291.0903,-144.9555;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-224.0903,62.04449;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-74.0964,139.0445;Float;False;Property;_XrayColor;_XrayColor;1;0;Create;True;0;0;False;0;0.1458694,0.1744198,0.2794118,0.522;0.09290452,0.1838235,0.08245026,0.172;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;2;-161,-69;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;6.909729,-35.95547;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1544.631,-169.1708;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1765.159,104.8286;Float;False;InstancedProperty;_speed;speed;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1102.339,-243.7998;Float;True;Property;_BumpMap;_BumpMap;2;0;Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;18;-1898.63,-34.17067;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;15;-1378.631,-92.17069;Float;False;Property;_AnimatedUv;AnimatedUv;6;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1807.63,-219.1709;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1689.63,-35.17067;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;276,74;Float;False;True;2;Float;ASEMaterialInspector;0;1;xray;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;3;1;False;-1;10;False;-1;2;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;7;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Xray=True;True;2;0;False;False;False;False;False;False;False;False;False;False;0;False;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;1;1;24;0
WireConnection;1;2;23;0
WireConnection;1;3;22;0
WireConnection;11;0;1;0
WireConnection;7;0;11;0
WireConnection;7;1;13;0
WireConnection;10;0;5;1
WireConnection;10;1;14;0
WireConnection;6;0;7;0
WireConnection;6;1;10;0
WireConnection;2;0;6;0
WireConnection;2;1;6;0
WireConnection;2;2;6;0
WireConnection;2;3;6;0
WireConnection;8;0;2;0
WireConnection;8;1;9;0
WireConnection;16;0;19;0
WireConnection;16;1;17;0
WireConnection;20;1;15;0
WireConnection;18;0;21;0
WireConnection;15;1;19;0
WireConnection;15;0;16;0
WireConnection;17;0;18;0
WireConnection;4;0;8;0
ASEEND*/
//CHKSM=B24F1AB6B10A0132AB4D36335ACF28B32AE5909D
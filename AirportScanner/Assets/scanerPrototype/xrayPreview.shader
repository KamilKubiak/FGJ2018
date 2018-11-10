// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "XrayPreviewPostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_xrayRT("xrayRT", 2D) = "white" {}
		_zoomMask("zoomMask", 2D) = "white" {}
		_MoouseCoords("_MoouseCoords", Vector) = (0,0,0,0)
		_SizeOffset("_SizeOffset", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _zoomMask;
			uniform float4 _SizeOffset;
			uniform float4 _MoouseCoords;
			uniform sampler2D _xrayRT;
			uniform float4 _xrayRT_ST;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv51 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult54 = (float2(_SizeOffset.x , _SizeOffset.y));
				float2 temp_output_52_0 = ( uv51 * appendResult54 );
				float2 appendResult56 = (float2(_SizeOffset.z , _SizeOffset.w));
				float2 appendResult58 = (float2(_MoouseCoords.x , _MoouseCoords.y));
				float4 tex2DNode48 = tex2D( _zoomMask, ( ( temp_output_52_0 + appendResult56 ) - appendResult58 ) );
				float2 uv_xrayRT = i.uv.xy * _xrayRT_ST.xy + _xrayRT_ST.zw;
				float4 lerpResult50 = lerp( tex2D( _MainTex, uv_MainTex ) , ( tex2DNode48 * tex2D( _xrayRT, uv_xrayRT ) ) , tex2DNode48.a);
				

				finalColor = lerpResult50;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15800
-7;238;1746;1004;1224.768;1091.828;1.184282;True;False
Node;AmplifyShaderEditor.Vector4Node;53;-1083.325,-841.1688;Float;False;Property;_SizeOffset;_SizeOffset;3;0;Create;True;0;0;False;0;0,0,0,0;32,24,0.5,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-1093.325,-662.1688;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;54;-856.0249,-894.8687;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;57;-303.9374,-1113.5;Float;False;Property;_MoouseCoords;_MoouseCoords;2;0;Create;True;0;0;False;0;0,0,0,0;19.34375,26.34375,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;56;-781.5237,-670.2693;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-699.5021,-860.8685;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-344.1639,-780.1803;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-138.8374,-746.4003;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1067.436,-387.4369;Float;False;1441.289;476.5997;Final Composition;3;2;1;47;Final Composition;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;60;87.0545,-918.4209;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-1017.436,-207.7365;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;-421.5675,-642.7869;Float;True;Property;_zoomMask;zoomMask;1;0;Create;True;0;0;False;0;None;0000000000000000f000000000000000;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;47;-830.0227,-295.0229;Float;True;Property;_xrayRT;xrayRT;0;0;Create;True;0;0;False;0;None;247333991b120d64085385a0971e58b6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-474.4904,-354.3003;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-18.36109,-572.5203;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-576.783,-553.7791;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;9.0625,-726.3004;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;50;108.0652,-513.9944;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-377.1397,-905.1605;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;650.6996,-265.2;Float;False;True;2;Float;ASEMaterialInspector;0;2;XrayPreviewPostProcess;c71b220b631b6344493ea3cf87110c93;0;0;;1;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;1;0;FLOAT4;0,0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1071,192.5;Float;False;1215;457;X;0;X;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1070.199,782.9008;Float;False;1658.099;1099.398;Grain;0;Grain;1,1,1,1;0;0
WireConnection;54;0;53;1
WireConnection;54;1;53;2
WireConnection;56;0;53;3
WireConnection;56;1;53;4
WireConnection;52;0;51;0
WireConnection;52;1;54;0
WireConnection;55;0;52;0
WireConnection;55;1;56;0
WireConnection;58;0;57;1
WireConnection;58;1;57;2
WireConnection;60;0;55;0
WireConnection;60;1;58;0
WireConnection;48;1;60;0
WireConnection;2;0;1;0
WireConnection;49;0;48;0
WireConnection;49;1;47;0
WireConnection;62;0;56;0
WireConnection;62;1;52;0
WireConnection;59;0;51;0
WireConnection;59;1;58;0
WireConnection;50;0;2;0
WireConnection;50;1;49;0
WireConnection;50;2;48;4
WireConnection;61;0;52;0
WireConnection;61;1;56;0
WireConnection;0;0;50;0
ASEEND*/
//CHKSM=0F702B4256FDD67612FA636DCE472759FBDC3FD3
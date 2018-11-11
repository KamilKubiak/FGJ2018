// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "XrayPreviewPostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_zoomMask("zoomMask", 2D) = "white" {}
		_MoouseCoords("_MoouseCoords", Vector) = (0,0,0,0)
		_SizeOffset("_SizeOffset", Vector) = (0,0,0,0)
		_xrayRT("xrayRT", 2D) = "white" {}
		_scannerOpacity("_scannerOpacity", Float) = 0
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
			uniform float _scannerOpacity;

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
				float2 appendResult56 = (float2(_SizeOffset.z , _SizeOffset.w));
				float2 appendResult58 = (float2(_MoouseCoords.x , _MoouseCoords.y));
				float4 tex2DNode48 = tex2D( _zoomMask, ( ( ( uv51 * appendResult54 ) + appendResult56 ) - appendResult58 ) );
				float2 uv_xrayRT = i.uv.xy * _xrayRT_ST.xy + _xrayRT_ST.zw;
				float4 lerpResult50 = lerp( tex2D( _MainTex, uv_MainTex ) , ( tex2DNode48 * tex2D( _xrayRT, uv_xrayRT ) ) , ( tex2DNode48.a * _scannerOpacity ));
				float2 uv69 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult87 = smoothstep( 0.25 , 0.75 , length( ( uv69 - float2( 0.5,0.5 ) ) ));
				float temp_output_90_0 = saturate( ( ( smoothstepResult87 - 0.25 ) * 2.0 ) );
				float4 temp_output_82_0 = ( ( temp_output_90_0 * float4(0,1,0,1) * _MoouseCoords.z ) + ( _MoouseCoords.w * float4(1,0,0,1) ) );
				float4 lerpResult86 = lerp( lerpResult50 , temp_output_82_0 , ( temp_output_90_0 * ( _MoouseCoords.z + _MoouseCoords.w ) ));
				

				finalColor = lerpResult86;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15800
50;320;1746;1004;-399.7577;1332.313;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;694.284,-781.7511;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;53;-1162.325,-877.1688;Float;False;Property;_SizeOffset;_SizeOffset;2;0;Create;True;0;0;False;0;0,0,0,0;2.035,1.87,0.5,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;72;950.7976,-824.0782;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-1262.325,-642.1688;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;54;-856.0249,-894.8687;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;73;197.4614,-1059.388;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-689.1824,-727.8218;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;57;-196.7277,-1122.329;Float;False;Property;_MoouseCoords;_MoouseCoords;1;0;Create;True;0;0;False;0;0,0,0,0;1.0175,0.5794474,-0.26,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;87;239.1412,-1229.87;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-695.5021,-875.4687;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-148.264,-869.6796;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;47.86263,-596.3989;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;66;-1344.256,-450.7537;Float;True;Property;_xrayRT;xrayRT;3;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;473.5313,-1277.105;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;60;100.0545,-936.6208;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-1105.906,-387.5801;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;667.8429,-1325.34;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-885.436,-450.4369;Float;False;1441.289;476.5997;Final Composition;3;2;1;47;Final Composition;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;79;751.9936,-1139.572;Float;False;Constant;_Color0;Color 0;5;0;Create;True;0;0;False;0;0,1,0,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;90;863.8773,-1262.599;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-835.436,-270.7365;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;333.9657,-767.6422;Float;True;Property;_zoomMask;zoomMask;0;0;Create;True;0;0;False;0;None;66e159d973998754c940e091ae8d9448;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;427.4817,-572.5156;Float;False;Property;_scannerOpacity;_scannerOpacity;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;-598.0227,-432.0229;Float;True;Property;_xrayRTSam;xrayRTSam;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;81;761.3916,-965.1956;Float;False;Constant;_Color1;Color 1;5;0;Create;True;0;0;False;0;1,0,0,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;16.71937,-207.7741;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;1229.44,-1313.97;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;653.9951,-631.281;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;490.8955,-1020.242;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;1354.361,-887.6542;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-18.36109,-572.5203;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;1377.065,-1112.072;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;1108.955,-1108.202;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;1051.708,-248.6095;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;84;1706.013,-510.5298;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;71;957.8052,-501.9434;Float;True;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;83;1518.887,-963.2974;Float;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;64;-967.7853,-523.0009;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;1185.286,-511.8264;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;74;1430.252,-739.6022;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;68;-755.0559,-549.4093;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;86;1735.629,-1200.417;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;77;672.1486,-518.2201;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;967.7976,-703.0782;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1891.95,-1067.633;Float;False;True;2;Float;ASEMaterialInspector;0;2;XrayPreviewPostProcess;c71b220b631b6344493ea3cf87110c93;0;0;;1;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;1;0;FLOAT4;0,0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1071,192.5;Float;False;1215;457;X;0;X;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1070.199,782.9008;Float;False;1658.099;1099.398;Grain;0;Grain;1,1,1,1;0;0
WireConnection;72;0;69;0
WireConnection;54;0;53;1
WireConnection;54;1;53;2
WireConnection;73;0;72;0
WireConnection;56;0;53;3
WireConnection;56;1;53;4
WireConnection;87;0;73;0
WireConnection;52;0;51;0
WireConnection;52;1;54;0
WireConnection;55;0;52;0
WireConnection;55;1;56;0
WireConnection;58;0;57;1
WireConnection;58;1;57;2
WireConnection;88;0;87;0
WireConnection;60;0;55;0
WireConnection;60;1;58;0
WireConnection;63;2;66;0
WireConnection;89;0;88;0
WireConnection;90;0;89;0
WireConnection;48;1;60;0
WireConnection;47;0;66;0
WireConnection;47;1;63;0
WireConnection;2;0;1;0
WireConnection;78;0;90;0
WireConnection;78;1;79;0
WireConnection;78;2;57;3
WireConnection;75;0;48;4
WireConnection;75;1;76;0
WireConnection;92;0;57;3
WireConnection;92;1;57;4
WireConnection;80;0;57;4
WireConnection;80;1;81;0
WireConnection;49;0;48;0
WireConnection;49;1;47;0
WireConnection;82;0;78;0
WireConnection;82;1;80;0
WireConnection;91;0;90;0
WireConnection;91;1;92;0
WireConnection;50;0;2;0
WireConnection;50;1;49;0
WireConnection;50;2;75;0
WireConnection;84;0;50;0
WireConnection;84;1;74;0
WireConnection;84;2;85;0
WireConnection;83;0;82;0
WireConnection;64;0;57;3
WireConnection;64;1;57;4
WireConnection;85;0;57;3
WireConnection;85;1;57;4
WireConnection;74;0;83;0
WireConnection;74;3;90;0
WireConnection;68;0;63;0
WireConnection;68;1;64;0
WireConnection;86;0;50;0
WireConnection;86;1;82;0
WireConnection;86;2;91;0
WireConnection;77;0;76;0
WireConnection;70;0;69;0
WireConnection;0;0;86;0
ASEEND*/
//CHKSM=77AF01EC84A622CD2DDD2841F5DE3F99675E1FC4
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmpSupershapeTest"
{
	Properties
	{
		_shape2M("shape2M", Float) = 0
		_shape2N1("shape2N1", Float) = 0
		_shape2B("shape2B", Float) = 0
		_shape2A("shape2A", Float) = 0
		_shape1N3("shape1N3", Float) = 0
		_shape1N1("shape1N1", Float) = 0
		_shape2N2("shape2N2", Float) = 0
		_shape1M("shape1M", Float) = 0
		_shape1B("shape1B", Float) = 0
		_shape1A("shape1A", Float) = 0
		_shape1N2("shape1N2", Float) = 0
		_shape2N3("shape2N3", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform float _shape1M;
		uniform float _shape1A;
		uniform float _shape1N2;
		uniform float _shape1B;
		uniform float _shape1N3;
		uniform float _shape1N1;
		uniform float _shape2M;
		uniform float _shape2A;
		uniform float _shape2N2;
		uniform float _shape2B;
		uniform float _shape2N3;
		uniform float _shape2N1;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_1_0_g4 = atan2( ase_vertex3Pos.y , ase_vertex3Pos.z );
			float temp_output_4_0_g4 = _shape1M;
			float temp_output_19_0 = abs( pow( ( pow( abs( cos( ( ( temp_output_1_0_g4 * 0.25 * temp_output_4_0_g4 ) / _shape1A ) ) ) , _shape1N2 ) + pow( abs( sin( ( ( temp_output_1_0_g4 * 0.25 * temp_output_4_0_g4 ) / _shape1B ) ) ) , _shape1N3 ) ) , ( -1.0 / _shape1N1 ) ) );
			float temp_output_1_0_g3 = 0.0;
			float temp_output_4_0_g3 = _shape2M;
			float temp_output_18_0 = abs( pow( ( pow( abs( cos( ( ( temp_output_1_0_g3 * 0.25 * temp_output_4_0_g3 ) / _shape2A ) ) ) , _shape2N2 ) + pow( abs( sin( ( ( temp_output_1_0_g3 * 0.25 * temp_output_4_0_g3 ) / _shape2B ) ) ) , _shape2N3 ) ) , ( -1.0 / _shape2N1 ) ) );
			float temp_output_26_0 = cos( 0.0 );
			float3 temp_cast_0 = (( ( temp_output_19_0 * cos( 0.0 ) * temp_output_18_0 * temp_output_26_0 ) + ( temp_output_19_0 * sin( 0.0 ) * temp_output_18_0 * temp_output_26_0 ) + ( temp_output_18_0 * sin( 0.0 ) ) )).xxx;
			v.vertex.xyz += temp_cast_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
755.2;73.6;779;712;1384.209;541.067;2.651629;False;False
Node;AmplifyShaderEditor.PosVertexDataNode;22;-1420.773,40.82494;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1100.53,812.221;Float;False;Property;_shape2A;shape2A;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1104.531,455.2223;Float;False;Property;_shape1N1;shape1N1;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;21;-1103.83,76.32276;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1089.75,1260.453;Float;False;Property;_shape2N3;shape2N3;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1110.999,187.8764;Float;False;Property;_shape1A;shape1A;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1108.843,368.9818;Float;False;Property;_shape1M;shape1M;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1113.155,280.585;Float;False;Property;_shape1B;shape1B;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1102.686,904.9296;Float;False;Property;_shape2B;shape2B;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1098.374,993.3265;Float;False;Property;_shape2M;shape2M;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1091.688,1079.567;Float;False;Property;_shape2N1;shape2N1;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1098.374,1167.963;Float;False;Property;_shape2N2;shape2N2;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1100.219,638.4834;Float;False;Property;_shape1N3;shape1N3;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1108.843,543.6187;Float;False;Property;_shape1N2;shape1N2;15;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;26;-701.1059,649.4026;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;28;-701.1057,758.6458;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;18;-743.9287,985.2606;Float;False;RadiusForAngle;-1;;3;313bbd868dbbfc947859ea0d1c610c68;0;7;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0.25;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;23;-710.7899,552.8456;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;30;-701.1057,850.106;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;19;-771.6735,324.8063;Float;False;RadiusForAngle;-1;;4;313bbd868dbbfc947859ea0d1c610c68;0;7;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0.25;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-233.6455,766.2679;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-236.1432,418.2467;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-231.1051,601.1324;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;40.87001,550.6909;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1;-942.944,-770.6733;Float;False;Property;_vUv;vUv;2;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector4Node;5;-945.0233,-136.5789;Float;False;Property;_vGlobalPosition;vGlobalPosition;4;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;4;-945.023,-313.2935;Float;False;Property;_vPosition;vPosition;3;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;2;-949.1809,-639.6965;Float;False;Property;_vNormal;vNormal;1;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;3;-955.418,-475.4551;Float;False;Property;_vGlobalNormal;vGlobalNormal;0;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;324.6643,-54.14597;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AmpSupershapeTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;22;2
WireConnection;21;1;22;3
WireConnection;18;2;12;0
WireConnection;18;3;13;0
WireConnection;18;4;15;0
WireConnection;18;5;14;0
WireConnection;18;6;16;0
WireConnection;18;7;17;0
WireConnection;19;1;21;0
WireConnection;19;2;6;0
WireConnection;19;3;7;0
WireConnection;19;4;8;0
WireConnection;19;5;9;0
WireConnection;19;6;10;0
WireConnection;19;7;11;0
WireConnection;29;0;18;0
WireConnection;29;1;30;0
WireConnection;24;0;19;0
WireConnection;24;1;23;0
WireConnection;24;2;18;0
WireConnection;24;3;26;0
WireConnection;27;0;19;0
WireConnection;27;1;28;0
WireConnection;27;2;18;0
WireConnection;27;3;26;0
WireConnection;33;0;24;0
WireConnection;33;1;27;0
WireConnection;33;2;29;0
WireConnection;0;11;33;0
ASEEND*/
//CHKSM=824F8A3B3B1696E006C456EA4286D439B79AE996
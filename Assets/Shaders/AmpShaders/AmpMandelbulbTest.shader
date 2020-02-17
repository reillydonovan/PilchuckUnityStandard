// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmpMandelbulbTest"
{
	Properties
	{
		_n("n", Float) = 0
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

		uniform float _n;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_24_0 = pow( sqrt( ( pow( ase_vertex3Pos.x , 2.0 ) + pow( ase_vertex3Pos.x , 2.0 ) + pow( ase_vertex3Pos.z , 2.0 ) ) ) , _n );
			float temp_output_20_0 = atan2( ( sqrt( ( pow( ase_vertex3Pos.x , 2.0 ) + pow( ase_vertex3Pos.y , 2.0 ) ) ) / ase_vertex3Pos.z ) , 0.0 );
			float temp_output_22_0 = atan( ( ase_vertex3Pos.x / ase_vertex3Pos.y ) );
			float3 temp_cast_0 = (( temp_output_24_0 * ( sin( ( _n * temp_output_20_0 ) ) * cos( ( _n * temp_output_22_0 ) ) ) )).xxx;
			float3 temp_cast_1 = (( temp_output_24_0 * ( sin( ( _n * temp_output_20_0 ) ) * sin( ( _n * temp_output_22_0 ) ) ) )).xxx;
			float3 temp_cast_2 = (( temp_output_24_0 * cos( ( _n * temp_output_20_0 ) ) )).xxx;
			v.vertex.xyz += 0;
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
680.8;73.6;853;712;1821.508;513.1417;2.490198;False;False
Node;AmplifyShaderEditor.PosVertexDataNode;8;-1766.939,51.31252;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;16;-1311.106,226.8868;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-1314.306,119.6869;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1135.106,153.2868;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;18;-962.3061,159.6869;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;21;-1084.572,529.1689;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-810.3058,162.8869;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;9;-1024.825,-291.1444;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;20;-664.7059,162.8867;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1753.41,-345.7197;Float;False;Property;_n;n;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATanOpNode;22;-898.9586,535.7979;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;11;-1039.383,-49.12508;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;10;-1032.104,-163.7659;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-821.0193,-192.881;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-313.5744,334.279;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-334.9424,77.61614;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-307.8487,494.8065;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-351.2006,-47.60704;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;31;-111.5023,282.7523;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;26;-157.4721,-207.4266;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-278.5612,697.3184;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;32;-124.0197,465.5345;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;28;-161.1287,-70.99284;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;13;-660.8865,-169.2249;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;59.39896,150.8682;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;24;48.24502,-343.7681;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;36;-107.5506,682.5428;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;59.31946,-157.5394;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;364.7213,68.17511;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;372.7852,289.9324;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;370.7692,179.0538;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.MatrixFromVectors;42;538.0952,195.1816;Float;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;839.0997,-33.34001;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AmpMandelbulbTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;8;2
WireConnection;15;0;8;1
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;21;0;8;1
WireConnection;21;1;8;2
WireConnection;19;0;18;0
WireConnection;19;1;8;3
WireConnection;9;0;8;1
WireConnection;20;0;19;0
WireConnection;22;0;21;0
WireConnection;11;0;8;3
WireConnection;10;0;8;1
WireConnection;12;0;9;0
WireConnection;12;1;10;0
WireConnection;12;2;11;0
WireConnection;30;0;23;0
WireConnection;30;1;20;0
WireConnection;27;0;23;0
WireConnection;27;1;22;0
WireConnection;33;0;23;0
WireConnection;33;1;22;0
WireConnection;25;0;23;0
WireConnection;25;1;20;0
WireConnection;31;0;30;0
WireConnection;26;0;25;0
WireConnection;35;0;23;0
WireConnection;35;1;20;0
WireConnection;32;0;33;0
WireConnection;28;0;27;0
WireConnection;13;0;12;0
WireConnection;34;0;31;0
WireConnection;34;1;32;0
WireConnection;24;0;13;0
WireConnection;24;1;23;0
WireConnection;36;0;35;0
WireConnection;29;0;26;0
WireConnection;29;1;28;0
WireConnection;38;0;24;0
WireConnection;38;1;29;0
WireConnection;40;0;24;0
WireConnection;40;1;36;0
WireConnection;39;0;24;0
WireConnection;39;1;34;0
WireConnection;42;0;38;0
WireConnection;42;1;39;0
WireConnection;42;2;40;0
WireConnection;0;11;42;0
ASEEND*/
//CHKSM=1700475F2390E384BF2452CF9AA9D3C669EFA733
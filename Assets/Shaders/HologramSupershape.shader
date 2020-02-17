// Hologram Shader built for World of Zero

Shader "Custom/HologramSupershape"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1, 0, 0, 1)
		_Bias("Bias", Float) = 0
		_ScanningFrequency("Scanning Frequency", Float) = 100
		_ScanningSpeed("Scanning Speed", Float) = 100

		[Space(20)][Header(Shape 1)][Space(20)]
		_Shape1A("_Shape1A", Range(-1000,1000)) = 1.0
		_Shape1B("_Shape1B", Range(-1000,1000)) = 1.0
		_Shape1M("_Shape1M", Range(-1000,1000)) = 1.0
		_Shape1N1("_Shape1N1", Range(-1000,1000)) = 1.0
		_Shape1N2("_Shape1N2", Range(-1000,1000)) = 1.0
		_Shape1N3("_Shape1N3", Range(-1000,1000)) = 1.0

		[Space(20)][Header(Shape 2)][Space(20)]
		_Shape2A("_Shape2A", Range(-1000,1000)) = 1.0
		_Shape2B("_Shape2B", Range(-1000,1000)) = 1.0
		_Shape2M("_Shape2M", Range(-1000,1000)) = 1.0
		_Shape2N1("_Shape2N1", Range(-1000,1000)) = 1.0
		_Shape2N2("_Shape2N2", Range(-1000,1000)) = 1.0
		_Shape2N3("_Shape2N3", Range(-1000,1000)) = 1.0
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
			LOD 100
			ZWrite Off
			Blend SrcAlpha One
			Cull Off

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				// make fog work
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(2)
					float4 vertex : SV_POSITION;
					float4 objVertex : TEXCOORD1;
					UNITY_VERTEX_OUTPUT_STEREO
				};

				fixed4 _Color;

				

				UNITY_DECLARE_SCREENSPACE_TEXTURE(_MainTex);
				//				sampler2D _MainTex;
								float4 _MainTex_ST;
								float _Bias;
								float _ScanningFrequency;
								float _ScanningSpeed;

								float _Shape1A;
								float _Shape1B;
								float _Shape1M;
								float _Shape1N1;
								float _Shape1N2;
								float _Shape1N3;

								float _Shape2A;
								float _Shape2B;
								float _Shape2M;
								float _Shape2N1;
								float _Shape2N2;
								float _Shape2N3;

								float radiusForAngle(float angle, float a, float b, float m, float n1, float n2, float n3) {
									float tempA = abs(cos(angle * m * 0.25) / a);
									float tempB = abs(sin(angle * m * 0.25) / b);
									float tempAB = pow(tempA, n2) + pow(tempB, n3);
									return abs(pow(tempAB, -1.0 / n1));
								}

								v2f vert(appdata v)
								{
									v2f o;
									UNITY_SETUP_INSTANCE_ID(v);
									UNITY_INITIALIZE_OUTPUT(v2f, o);
									UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
									o.objVertex = mul(unity_ObjectToWorld, v.vertex);
									o.vertex = UnityObjectToClipPos(v.vertex);
									o.uv = TRANSFORM_TEX(v.uv, _MainTex);
									UNITY_TRANSFER_FOG(o,o.vertex);
									return o;
								}

								fixed4 frag(v2f i) : SV_Target
								{
									UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
								// sample the texture
								fixed4 col = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv);
								// apply fog
								UNITY_APPLY_FOG(i.fogCoord, col);
								col = _Color * max(0, cos(i.objVertex.y * _ScanningFrequency + _Time.x * _ScanningSpeed) + _Bias);
								col *= 1 - max(0, cos(i.objVertex.x * _ScanningFrequency + _Time.x * _ScanningSpeed) + 0.9);
								col *= 1 - max(0, cos(i.objVertex.z * _ScanningFrequency + _Time.x * _ScanningSpeed) + 0.9);
								return col;
							}
							ENDCG
						}
		}
}
// Hologram Shader built for World of Zero

Shader "World of Zero/Hologram"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1, 0, 0, 1)
		_Bias("Bias", Float) = 0
		_ScanningFrequency("Scanning Frequency", Float) = 100
		_ScanningSpeed("Scanning Speed", Float) = 100
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
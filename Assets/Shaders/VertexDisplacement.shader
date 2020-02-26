Shader "Insight/VertexDisplacement" {
	Properties{
		[Space(20)][Header(MainTex)][Space(20)]
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_NormalTex("Normal Map", 2D) = "bump" {}
		_NormalMapIntensity("Normal Intensity", Range(0,3)) = 1
		_Shininess("Shininess", Range(0, 3)) = 0
		_ShineColor("Shine Color", Color) = (1,1,1,1)
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		[Space(20)][Header(Vertex Animation)][Space(20)]
		 _VertexAnimOffset("VertexAnimOffset", Range(-100,100)) = 1.0
		 _WaveValue1("WaveValue1", Range(-100,100)) = 1.0
		 _WaveValue2("WaveValue2", Range(-100,100)) = 1.0
		 _WaveValue3("WaveValue3", Range(-100,100)) = 1.0


	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200
			Cull Off

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
		   // #pragma surface surf Standard fullforwardshadows
		   #pragma surface surf Standard vertex:vert fullforwardshadows
			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;
			sampler2D _NormalTex;
			float _NormalMapIntensity;
			float _Shininess;
			fixed4 _ShineColor;

			 struct Input {
				 float2 uv_MainTex;
				 float2 uv_NormalTex;
				 float3 viewDir;
			 };

			 half _Glossiness;
			 half _Metallic;
			 float _WaveSpeed;
			 float _WaveFrequency;
			 float _Amplitude;
			 fixed4 _Color;

			 float _VertexAnimOffset;
			 float totalOffset;
			 float _WaveValue1;
			 float _WaveValue2;
			 float _WaveValue3;




			 void vert(inout appdata_full v, out Input o) {

				 UNITY_INITIALIZE_OUTPUT(Input, o);
				 // float time = _Time * _WaveSpeed;
				 // float waveValueA = sin(time + v.vertex.x * _WaveFrequency) * _Amplitude;
				 // v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveValueA, v.vertex.z);

				  totalOffset = _Time + _VertexAnimOffset;

		

				   v.vertex.xyz += sin((v.vertex.xyz + totalOffset * _WaveValue3) * _WaveValue2) * _WaveValue1;


				   // Y Axis Sin Wave Deformation
				 //  v.vertex.y += sin((v.vertex.y + totalOffset * _WaveValueY3) * _WaveValueY2) * _WaveValueY1;


				   // Z Axis Sin Wave Deformation
				  // v.vertex.z += sin((v.vertex.z + totalOffset * _WaveValueZ3) * _WaveValueZ2) * _WaveValueZ1;

			   }


			   void surf(Input IN, inout SurfaceOutputStandard o) {


				   fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				   float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));

				   normalMap.x *= _NormalMapIntensity;
				   normalMap.y *= _NormalMapIntensity;

				   // _Color;
				   o.Normal = normalize(normalMap.rgb);

				   half factor = dot(normalize(IN.viewDir), o.Normal);

				   o.Albedo = c.rgb;
				   o.Emission.rgb = _ShineColor * (_Shininess - factor * _Shininess);
				   o.Metallic = _Metallic;
				   o.Smoothness = _Glossiness;
				   o.Alpha = c.a;
			   }

			   ENDCG
		}
			FallBack "Diffuse"
}
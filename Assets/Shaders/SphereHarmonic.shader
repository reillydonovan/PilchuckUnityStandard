Shader "Custom/SphereHarmonic" {
	Properties{
		[Space(20)][Header(MainTex and ColorRamp)][Space(20)]
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_NormalTex("Normal Map", 2D) = "bump" {}
		_ColorRamp("ColorRamp",2D) = "white"{}
		_Blend("Blend",Range(0,1)) = 0.5

		[Space(20)][Header(Mask)][Space(20)]
		_Mask("Mask",2D) = "white"{}

		[Space(20)][Header(Adding Distortion)][Space(20)]
		_Noise("Noise", 2D) = "white" {}
		_Distortion("Distortion",Float) = 6

		[Space(20)][Header(Change ColorRamp)][Space(20)]
		_Hue("Hue", Range(0, 1.0)) = 0
		_Saturation("Saturation", Range(0, 1.0)) = 0.5
		_Brightness("Brightness", Range(0, 1.0)) = 0.5
		_Contrast("Contrast", Range(0, 1.0)) = 0.5

		_NormalMapIntensity("Normal Intensity", Range(0,3)) = 1
		_TintAmount("Tint Amount", Range(0,1)) = 0.5
		_ColorA("Color A", Color) = (1,1,1,1)
		_ColorB("Color B", Color) = (1,1,1,1)
		_WaveSpeed("Wave Speed", Range(0,80)) = 0
		_WaveFrequency("Wave Frequency", Range(0,5)) = 0
		_Amplitude("Wave Amplitude", Range(-1,1)) = 0


		_Shininess("Shininess", Range(0, 3)) = 0
		_ShineColor("Shine Color", Color) = (1,1,1,1)
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_ScrollXSpeed("X Scroll Speed", Range(0,10)) = 0
		_ScrollYSpeed("Y Scroll Speed", Range(0,10)) = 0

		xMod1Period("xMod1Period", Range(-100,100)) = 0.0 //how many ups and downs there are
		xMod1PhaseOffset("xMod1PhaseOffset", Range(-100,100)) = 0.0 //how far the wave is shifted
		xMod1Scale("xMod1Scale", Range(-100,100)) = 0.0 //how big the wave is
		xMod1YOffset("xMod1YOffset", Range(-100,100)) = 0.0 //how big the base of the wave is
		xMod1TimeResponse("xMod1TimeResponse", Range(-100,100)) = 0.0 //the amount the wave moves with time

		//set of vars exposed to create waves parallel to the 'longitude'
		// of the sphere
		yMod1Period("yMod1Period", Range(-100,100)) = 0.0 //how many ups and downs there are
		yMod1PhaseOffset("yMod1PhaseOffset", Range(-100, 100)) = 0.0 //how far the wave is shifted
		yMod1Scale("yMod1Scale", Range(-100, 100)) = 0.0 //how big the wave is
		yMod1YOffset("yMod1YOffset", Range(-100, 100)) = 0.0 //how big the base of the wave is
		yMod1TimeResponse("yMod1TimeResponse", Range(-100, 100)) = 0.0 //the amount the wave moves with time

		_VertexAnimOffset("VertexAnimOffset", Range(-100,100)) = 1.0
		_Shape1A("_Shape1A", Range(-100,100)) = 1.0
		_Shape1B("_Shape1B", Range(-100,100)) = 1.0
		_Shape1M("_Shape1M", Range(-100,100)) = 1.0
		_Shape1N1("_Shape1N1", Range(-100,100)) = 1.0
		_Shape1N2("_Shape1N2", Range(-100,100)) = 1.0
		_Shape1N3("_Shape1N3", Range(-100,100)) = 1.0

		_Shape2A("_Shape2A", Range(-100,100)) = 1.0
		_Shape2B("_Shape2B", Range(-100,100)) = 1.0
		_Shape2M("_Shape2M", Range(-100,100)) = 1.0

		_Shape2N1("_Shape2N1", Range(-100,100)) = 1.0
		_Shape2N2("_Shape2N2", Range(-100,100)) = 1.0
		_Shape2N3("_Shape2N3", Range(-100,100)) = 1.0





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

			fixed _ScrollXSpeed;
			fixed _ScrollYSpeed;
			sampler2D _MainTex, _ColorRamp, _Noise, _Mask;
			float4 _RimColor;
			sampler2D _NormalTex;
			float4 _MainTint;
			float _NormalMapIntensity;
			float _Shininess;
			fixed4 _ShineColor;

			float4 _ColorA;
			float4 _ColorB;
			float _TintAmount;
			float _WaveSpeed;
			float _WaveFrequency;
			float _Amplitude;
			// float _OffsetVal;


			 struct Input {
				 float2 uv_MainTex;
				 float2 uv_Mask;
				 float2 uv_NormalTex;
				 float3 vertColor;
				 float2 uv_ColorRamp;
				 float3 viewDir;
				 float3 worldPos;
			 };

			 float4 _ColorRamp_ST;
			 float _Distortion;
			 float _Blend;

			 half _Glossiness;
			 half _Metallic;
			 fixed4 _Color;


			 float3 _vNormal;
			 float3 _vGlobalNormal;
			 float3 _vPosition;
			 float4 _vGlobalPosition;

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

			 int xMod1Period = 4; //how many ups and downs there are
			 float xMod1PhaseOffset = 1.0f; //how far the wave is shifted
			 float xMod1Scale = 2.0f; //how big the wave is
			 float xMod1YOffset = 1.1f; //how big the base of the wave is
			 float xMod1TimeResponse = 1.0f; //the amount the wave moves with time

			 //set of vars exposed to create waves parallel to the 'longitude'
			 // of the sphere
			 int yMod1Period = 4; //how many ups and downs there are
			 float yMod1PhaseOffset = 1.0f; //how far the wave is shifted
			 float yMod1Scale = 2.0f; //how big the wave is
			 float yMod1YOffset = 1.1f; //how big the base of the wave is
			 float yMod1TimeResponse = 1.0f; //the amount the wave moves with time

			 UNITY_INSTANCING_BUFFER_START(Props)
				 // put more per-instance properties here
				 UNITY_INSTANCING_BUFFER_END(Props)

				 fixed _Hue, _Saturation, _Brightness, _Contrast;


			 inline float3 applyHue(float3 aColor, float aHue)
			 {
				 float angle = radians(aHue);
				 float3 k = float3(0.57735, 0.57735, 0.57735);
				 float cosAngle = cos(angle);

				 return aColor * cosAngle + cross(k, aColor) * sin(angle) + k * dot(k, aColor) * (1 - cosAngle);
			 }

			 inline float4 applyHSBCEffect(float4 startColor, fixed4 hsbc)
			 {
				 float hue = 360 * hsbc.r;
				 float saturation = hsbc.g * 2;
				 float brightness = hsbc.b * 2 - 1;
				 float contrast = hsbc.a * 2;

				 float4 outputColor = startColor;
				 outputColor.rgb = applyHue(outputColor.rgb, hue);
				 outputColor.rgb = (outputColor.rgb - 0.5f) * contrast + 0.5f;
				 outputColor.rgb = outputColor.rgb + brightness;
				 float3 intensity = dot(outputColor.rgb, float3(0.39, 0.59, 0.11));
				 outputColor.rgb = lerp(intensity, outputColor.rgb, saturation);

				 return outputColor;
			 }

			 float radiusForAngle(float angle, float a, float b, float m, float n1, float n2, float n3) {
				 float tempA = abs(cos(angle * m * 0.25) / a);
				 float tempB = abs(sin(angle * m * 0.25) / b);
				 float tempAB = pow(tempA, n2) + pow(tempB, n3);
				 return abs(pow(tempAB, -1.0 / n1));
			 }


			 float GetRadius(float phi, float theta, float time = 0)
			 {
				 return xMod1YOffset + xMod1Scale * sin(xMod1TimeResponse*time + theta * xMod1Period*time*.1f + xMod1PhaseOffset * time) +
					 yMod1YOffset + yMod1Scale * sin(yMod1TimeResponse*time + phi * yMod1Period*time*.1f + yMod1PhaseOffset * time);
			 }


			 void vert(inout appdata_full v, out Input o) {

				 UNITY_INITIALIZE_OUTPUT(Input, o);
				 float time = _Time * _WaveSpeed;

				 float waveValueA = sin(time + v.vertex.x * _WaveFrequency) * _Amplitude;
				 v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveValueA, v.vertex.z);
				 v.normal = normalize(float3(v.normal.x + waveValueA, v.normal.y, v.normal.z));
				 o.vertColor = float3(waveValueA, waveValueA, waveValueA);
				 // o.vertColor = v.color;

				  float r = length(v.vertex.xyz);
				  float phi = atan2(v.vertex.y, v.vertex.x);
				  float theta = r == 0.0 ? 0.0 : asin(v.vertex.z / r);
				  float radius = GetRadius(phi, theta, _Time);

				  float superRadiusPhi = radiusForAngle(phi, _Shape1A, _Shape1B, _Shape1M, _Shape1N1, _Shape1N2, _Shape1N3);
				  float superRadiusTheta = radiusForAngle(theta, _Shape2A, _Shape2B, _Shape2M, _Shape2N1, _Shape2N2, _Shape2N3);

				  v.vertex.x = r * sin(phi) * cos(theta) * radius;
				  v.vertex.y = r *  sin(phi) * sin(theta) * radius;
				  v.vertex.z = r * cos(phi) * radius;

			  }


			  void surf(Input IN, inout SurfaceOutputStandard o) {

				  float3 tintColor = lerp(_ColorA, _ColorB, IN.vertColor).rgb;

				  fixed2 scrolledUV = IN.uv_MainTex;
				  float2 scrolledNM = IN.uv_NormalTex;


				  fixed xScrollValue = _ScrollXSpeed * _Time;
				  fixed yScrollValue = _ScrollYSpeed * _Time;

				  scrolledUV += fixed2(xScrollValue, yScrollValue);
				  scrolledNM += fixed2(xScrollValue, yScrollValue);

				  fixed4 c = tex2D(_MainTex, scrolledUV);
				  float3 normalMap = UnpackNormal(tex2D(_NormalTex, scrolledNM));
				  float noise = tex2D(_Noise, IN.uv_MainTex);

				  normalMap.x *= _NormalMapIntensity;
				  normalMap.y *= _NormalMapIntensity;

				  // _Color;
				 o.Normal = normalize(normalMap.rgb);
				 half factor = dot(normalize(IN.viewDir), o.Normal);
				 float2 rim = dot(normalize(IN.viewDir), o.Normal);
				 float2 distortion = noise * _Distortion;
				 //float2 rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));

				 float4 mask = tex2D(_Mask, IN.uv_Mask);
				 float4 colorRamp = tex2D(_ColorRamp, TRANSFORM_TEX(rim, _ColorRamp)*distortion)*mask;

				 colorRamp = max(colorRamp, (1 - mask)* c);

				 fixed4 hsbc = fixed4(_Hue, _Saturation, _Brightness, _Contrast);
				 float4 colorRampHSBC = applyHSBCEffect(colorRamp, hsbc);
				 o.Albedo = lerp(c, colorRampHSBC, _Blend);
				 // o.Albedo = c.rgb + ( tintColor * _TintAmount); // *(tintColor * _TintAmount);
				 // o.Albedo = IN.vertColor.rgb;
				  o.Emission.rgb = _ShineColor * (_Shininess - factor * _Shininess);
				  o.Metallic = _Metallic;
				  o.Smoothness = _Glossiness;
				  o.Alpha = c.a;
			  }
			  /*
			  void surf(Input i, inout SurfaceOutputStandard o)
			  {

				  vUv = uv;

				  vNormal = normal;
				  vGlobalNormal = normalize(normalMatrix * normal);

				  vPosition = superPositionForPosition(position);
				  vGlobalPosition = projectionMatrix * modelViewMatrix * vec4(vPosition, 1.0);

				  gl_Position = vGlobalPosition;
			  }
			  */

			  ENDCG
		}
			FallBack "Diffuse"
}
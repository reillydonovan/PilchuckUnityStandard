// ---------------------------------------------------------------------
//
// Copyright (c) 2018 Magic Leap, Inc. All Rights Reserved.
// Use of this file is governed by the Creator Agreement, located
// here: https://id.magicleap.com/creator-terms
//
// ---------------------------------------------------------------------

Shader "Insight/BRDF/TextureCube"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Color Map/Alpha Spec", 2D) = "black" {}
		_RampLight("RampLight", 2D) = "Black" {}
		_Fade("Fade", Range(0.0,2.0)) = 1.0
		_Luma("LumaBoost", Range(0.0,2.0)) = 0.0
		_RefCube("LightCube", CUBE) = "" {}
		_Reflect("LightMulti", Range(0.0,5)) = 0.0
		_LightVector("LightVector", Vector) = (0,0,0,0)

		[Space(20)][Header(Shape 1)][Space(20)]
		_Shape1A("_Shape1A", Range(-100,100)) = 1.0
		_Shape1B("_Shape1B", Range(-100,100)) = 1.0
		_Shape1M("_Shape1M", Range(-100,100)) = 1.0
		_Shape1N1("_Shape1N1", Range(-100,100)) = 1.0
		_Shape1N2("_Shape1N2", Range(-100,100)) = 1.0
		_Shape1N3("_Shape1N3", Range(-100,100)) = 1.0

		[Space(20)][Header(Shape 2)][Space(20)]
		_Shape2A("_Shape2A", Range(-100,100)) = 1.0
		_Shape2B("_Shape2B", Range(-100,100)) = 1.0
		_Shape2M("_Shape2M", Range(-100,100)) = 1.0
		_Shape2N1("_Shape2N1", Range(-100,100)) = 1.0
		_Shape2N2("_Shape2N2", Range(-100,100)) = 1.0
		_Shape2N3("_Shape2N3", Range(-100,100)) = 1.0

	}

		SubShader
		{
			Tags { "RenderType" = "opaque" "Queue" = "geometry"}

			Lighting Off
			Cull Off
			CGPROGRAM
			#pragma surface surf RampLight novertexlights exclude_path:prepass noambient noforwardadd nolightmap nodirlightmap vertex:vert
			#pragma target 3.0

			struct Input
			{
				float2 uv_MainTex;
				float2 uv_Ramp;
				float3 worldRefl;
			  INTERNAL_DATA
			};

			sampler2D _MainTex;
			sampler2D _RampLight;
			half _Luma;
			half _Fade;
			float4 _Color;
			half _Reflect;
			samplerCUBE _RefCube;
			float4 _LightVector;


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

			half4 LightingRampLight(SurfaceOutput s, half3 lightDir, half3 viewDir, fixed atten)
			{
				float light = dot(s.Normal,_LightVector);
				float rim = dot(s.Normal,viewDir);
				float diff = (light*.5) + .5;

				float2 brdfdiff = float2(rim, diff);
				float3 BRDFLight = tex2D(_RampLight, brdfdiff.xy).rgb;

				half3 BRDFColor = (s.Albedo);


				half4 c;
				c.rgb = BRDFColor * BRDFLight*_Fade;
				c.a = _Color.a;
				return c;
			}

			float radiusForAngle(float angle, float a, float b, float m, float n1, float n2, float n3) {
				float tempA = abs(cos(angle * m * 0.25) / a);
				float tempB = abs(sin(angle * m * 0.25) / b);
				float tempAB = pow(tempA, n2) + pow(tempB, n3);
				return abs(pow(tempAB, -1.0 / n1));
			}

			void vert(inout appdata_full v, out Input o) {

				UNITY_INITIALIZE_OUTPUT(Input, o);

				float r = length(v.vertex.xyz);
				float phi = atan2(v.vertex.y, v.vertex.x);
				float theta = r == 0.0 ? 0.0 : asin(v.vertex.z / r);

				float superRadiusPhi = radiusForAngle(phi, _Shape1A, _Shape1B, _Shape1M, _Shape1N1, _Shape1N2, _Shape1N3);
				float superRadiusTheta = radiusForAngle(theta, _Shape2A, _Shape2B, _Shape2M, _Shape2N1, _Shape2N2, _Shape2N3);

				v.vertex.x = r * superRadiusPhi * cos(phi) * superRadiusTheta * cos(theta);
				v.vertex.y = r * superRadiusPhi * sin(phi) * superRadiusTheta * cos(theta);
				v.vertex.z = r * superRadiusPhi * sin(theta);

			}

			void surf(Input IN, inout SurfaceOutput o)
			{
				half4 maintex = tex2D(_MainTex, IN.uv_MainTex);
				float3 refcube = texCUBE(_RefCube, WorldReflectionVector(IN, o.Normal)).rgb*_Reflect;
				o.Albedo = maintex + refcube;
				o.Emission = (maintex.a*(maintex*_Color))*_Luma;
			}
			ENDCG
		}

			Fallback "Diffuse"
}
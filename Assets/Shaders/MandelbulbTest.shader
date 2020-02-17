Shader "Custom/MandelbulbTest" {
	Properties{

		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Amount("Amount", Range(-100,100)) = 1.0

		

		_VertexAnimOffset("VertexAnimOffset", Range(-100,100)) = 1.0
		_n("_n", Range(-1000,1000)) = 1.0
	





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

			struct Input {
				float2 uv_MainTex;
			};

			half _Glossiness;
			half _Metallic;
			fixed4 _Color;

			float _n;


			void surf(Input IN, inout SurfaceOutputStandard o) {
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;
			}

			

			void vert(inout appdata_full v) {
				//  v.vertex.xz += v.normal.xz * _Amount * abs(sin(_Time * 10)) * v.color.x;
				//  v.vertex.y += _Amount * abs(sin(_Time * 200)) * v.color.y;

				//Fat Mesh
			 //  totalOffset = _Time + _VertexAnimOffset;
			 //  v.vertex.xyz += v.normal * _FatValue1;

				//Wave Mesh
			 //   v.vertex.x += sin((v.vertex.y + _Time * _Value3 ) * _Value2 ) * _Value1;
		  //   v.vertex.x += sin((v.vertex.x + _Time * _Value3 ) * _Value2 ) * _Value1;
		 //     v.vertex.y += sin((v.vertex.y + _Time * _Value3 ) * _Value2 ) * _Value1;

				  // X Axis Sin Wave Deformation
				float r = sqrt(v.vertex.x * v.vertex.x + v.vertex.y * v.vertex.y + v.vertex.z * v.vertex.z);

				  float phi = atan2(v.vertex.y, v.vertex.x);
				  float theta = atan2(sqrt(v.vertex.x * v.vertex.x + v.vertex.y * v.vertex.y), v.vertex.z);


			  v.vertex.x = pow(r,_n) * sin(theta * _n) * cos(phi * _n);
			  v.vertex.y = pow(r,_n) * sin(theta* _n) * sin(phi * _n);
			  v.vertex.z = pow(r,_n) * cos(theta * _n);


			  // Y Axis Sin Wave Deformation
			 // v.vertex.y += sin((v.vertex.y + totalOffset * _WaveValueY3) * _WaveValueY2) * _WaveValueY1;


			  // Z Axis Sin Wave Deformation
			 // v.vertex.z += sin((v.vertex.z + totalOffset * _WaveValueZ3) * _WaveValueZ2) * _WaveValueZ1;

			//Bubbling Mesh
		 //   v.vertex.xyz += v.normal * ( sin((v.vertex.x + totalOffset * _BubbleValue3) * _BubbleValue2) + cos((v.vertex.z + totalOffset* _BubbleValue3) * _BubbleValue2)) * _BubbleValue1;

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
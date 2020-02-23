Shader "Kinect/SceneMeshVShader"
{
    Properties
    {
		//_Color("Color", Color) = (1,1,1,1)
		_ColorTex("Albedo (RGB)", 2D) = "white" {}
		_MaxEdgeLen("Max edge length", Range(0.01, 0.5)) = 0.1
	}

    SubShader
    {
		Tags { "Queue" = "Transparent" "RenderType" = "Opaque" "IgnoreProjector" = "True" }
		//LOD 200

		Cull Off
		Blend Off

		Pass
        {
            CGPROGRAM
            #pragma vertex vert
			#pragma geometry geom
            #pragma fragment frag

			#pragma target 5.0


			#include "UnityCG.cginc"

			//fixed4 _Color;

			sampler2D _ColorTex;
			float4 _ColorTex_TexelSize;
			float4 _ColorTex_ST;

			float _MaxEdgeLen;

			StructuredBuffer<uint> _DepthMap;
			StructuredBuffer<float> _SpaceTable;

			int _CoarseFactor;
			int _IsPointCloud;
			float2 _SpaceScale;

			float2 _TexRes;
			float2 _Cxy;
			float2 _Fxy;

			float4x4 _Transform;
			float3 _PosMin;
			float3 _PosMax;


            struct v2f
            {
				uint idx : TEXCOORD0;
				float2 uv : TEXCOORD1;

				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 vertexPos : TEXCOORD2;
				bool mask : TEXCOORD3;
			};

			uint getDepthAt(uint di)
			{
				uint depth2 = 0;
				depth2 = _DepthMap[di >> 1];
				uint depth = di & 1 != 0 ? depth2 >> 16 : depth2 & 0xffff;

				return depth;
			}


			float3 getSpacePos(uint idx, float fDepth)
			{
				uint di = idx * 3;
				float3 spacePos = float3(_SpaceTable[di] * fDepth * _SpaceScale.x, _SpaceTable[di + 1] * fDepth * _SpaceScale.y, fDepth);

				return spacePos;
			}


			v2f initV2f(uint idx)
			{
				v2f o;

				UNITY_INITIALIZE_OUTPUT(v2f, o);
				o.idx = idx;

				uint dx = idx % (uint)_TexRes.x;
				uint dy = (uint)((idx - dx) / _TexRes.x);
				o.uv = float2((float)dx / _TexRes.x, (float)dy / _TexRes.y);

				uint depth = getDepthAt(idx);

				float fDepth = (float)depth * 0.001;
				float3 vPos = getSpacePos(idx, fDepth);

				float4 wPos = mul(_Transform, float4(vPos, 1.0));
				bool mask = wPos.x >= _PosMin.x && wPos.x <= _PosMax.x && wPos.y >= _PosMin.y && wPos.y <= _PosMax.y && wPos.z >= _PosMin.z && wPos.z <= _PosMax.z;

				o.vertex = UnityObjectToClipPos(vPos);
				o.vertexPos = vPos;
				o.mask = mask;

				return o;
			}


			v2f vert (appdata_full v)
            {
				float2 posDepth = v.texcoord; // (float2)v.vertex;
				uint dx = (uint)(posDepth.x * _TexRes.x);
				uint dy = (uint)(posDepth.y * _TexRes.y);
				uint idx = (dx + dy * _TexRes.x);

				return initV2f(idx);
            }

			float getMaxEdgeLen(float3 v0, float3 v1, float3 v2)
			{
				float maxEdgeLen = distance(v0, v1);
				maxEdgeLen = max(maxEdgeLen, distance(v1, v2));
				maxEdgeLen = max(maxEdgeLen, distance(v2, v0));

				return maxEdgeLen;
			}

			[maxvertexcount(6)]
			void geom(point v2f input[1], inout TriangleStream<v2f> triStream)
			{
				v2f p0 = input[0];
				uint idx = p0.idx;

				v2f p1 = initV2f(idx + _CoarseFactor);
				v2f p2 = initV2f(idx + _CoarseFactor * _TexRes.x);
				v2f p3 = initV2f(idx + _CoarseFactor * _TexRes.x + _CoarseFactor);

				if (p0.mask && p1.mask && p2.mask && getMaxEdgeLen(p0.vertexPos, p1.vertexPos, p2.vertexPos) < _MaxEdgeLen)
				{
					p0.normal = p1.normal = p2.normal = cross(normalize(p2.vertexPos - p0.vertexPos), normalize(p1.vertexPos - p0.vertexPos));

					triStream.Append(p0);
					triStream.Append(p1);
					triStream.Append(p2);
					triStream.RestartStrip();
				}

				if (p1.mask && p3.mask && p2.mask && getMaxEdgeLen(p1.vertexPos, p3.vertexPos, p2.vertexPos) < _MaxEdgeLen)
				{
					p1.normal = p3.normal = p2.normal = cross(normalize(p2.vertexPos - p1.vertexPos), normalize(p3.vertexPos - p1.vertexPos));

					triStream.Append(p1);
					triStream.Append(p3);
					triStream.Append(p2);
					triStream.RestartStrip();
				}
			}

			fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = tex2D(_ColorTex, i.uv);
				//fixed4 col = float4(1, 0, 0, 1);

				return col;
            }
            ENDCG
        }
    }

	FallBack "Diffuse"
}

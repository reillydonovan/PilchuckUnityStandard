//surface calculations
#ifndef MK_GLASS_SURFACE
	#define MK_GLASS_SURFACE

	#if MKGLASS_PRECALC
	void PreCalcParameters(inout MKGlassSurface mkts)
	{
		#if MKGLASS_V_DOT_N
			mkts.Pcp.VdotN = max(0.0, dot(mkts.Pcp.ViewDirection, mkts.Pcp.NormalDirection));
		#endif
		#if MKGLASS_V_DOT_L
			mkts.Pcp.VdotL = max(0.0 ,dot(mkts.Pcp.LightDirection, mkts.Pcp.ViewDirection));
		#endif
		#if MKGLASS_N_DOT_L
			mkts.Pcp.NdotL = max(0.0 , dot(mkts.Pcp.NormalDirection, mkts.Pcp.LightDirection));
		#endif
		#if MKGLASS_HV
			mkts.Pcp.HV = normalize(mkts.Pcp.LightDirection + mkts.Pcp.ViewDirection);
		#endif
		#if MKGLASS_N_DOT_HV
			mkts.Pcp.NdotHV = max(0.0, dot(mkts.Pcp.NormalDirection, mkts.Pcp.HV));
		#endif
		#if MKGLASS_ML_REF_N
			mkts.Pcp.MLrefN = reflect(-mkts.Pcp.LightDirection, mkts.Pcp.NormalDirection);
		#endif
		#ifdef MKGLASS_MV_REF_N
			mkts.Pcp.MVrefN = reflect(-mkts.Pcp.ViewDirection, mkts.Pcp.RNormalDirection);
		#endif
		#if MKGLASS_ML_DOT_V
			 mkts.Pcp.MLdotV = max(0.0, dot (-mkts.Pcp.LightDirection, mkts.Pcp.ViewDirection));
		#endif
		#if MKGLASS_ML_REF_N_DOT_V
			 mkts.Pcp.MLrefNdotV = max(0.0, dot(mkts.Pcp.MLrefN, mkts.Pcp.ViewDirection));
		#endif
	}
	#endif

	#if (_MK_ALBEDO_MAP && !_MK_DETAIL_MAP) || (!_MK_ALBEDO_MAP && !_MK_DETAIL_MAP)
	//get surface refraction and mix with albedo
	inline void MixAlbedoRefraction(inout fixed3 a, in fixed3 r, half lv)
	{
		a = lerp(r, a*r, lv);
	}
	#endif

	#if !_MK_ALBEDO_MAP && _MK_DETAIL_MAP
	//mix detail and refraction
	inline void MixDetailRefraction(inout fixed3 a, in fixed3 r, half lv)
	{
		a = lerp(r, a*r, lv);
	}
	#endif

	#if _MK_ALBEDO_MAP && _MK_DETAIL_MAP
	//mix albedo refraction detail
	inline void MixAlbedoDetailRefraction(inout fixed3 a, in fixed3 d, in fixed3 r, half lvM, half lvD)
	{
		a = lerp(r, a*r, lvM);
		a = lerp(a, a*d, lvD);
	}
	#endif

	//get surface color based on blendmode and color source
	#if MKGLASS_TEXCLR
		inline void SurfaceAlbedo(out fixed3 albedo, out fixed alpha, float2 uv)
		{
			fixed3 c = tex2D(_MainTex, uv).rgb * _Color;
			albedo = c.rgb;
			alpha = 1.0;
		}

		#if _MK_DETAIL_MAP
			inline void SurfaceDetail(out fixed3 detail, float2 uv)
			{
				detail = tex2D(_DetailAlbedoMap, uv).rgb * _DetailColor.rgb;
			}
		#endif

	#elif MKGLASS_VERTCLR
		inline void SurfaceAlbedo(out fixed3 albedo, out fixed alpha, fixed4 vrtColor)
		{
			albedo = vrtColor.rgb * _Color;
			alpha = 1.0;
		}
	#endif

	inline void SurfaceRefraction(out fixed3 refraction, float4 uv)
	{
		#if FAST_MODE
			refraction = tex2Dproj(_MKGlassRefraction, UNITY_PROJ_COORD(uv)).rgb;
		#else
			refraction = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(uv)).rgb;
		#endif
	}

	//only include initsurface when not meta pass
	#ifndef MK_GLASS_META_PASS
		/////////////////////////////////////////////////////////////////////////////////////////////
		// INITIALIZE SURFACE
		/////////////////////////////////////////////////////////////////////////////////////////////
		MKGlassSurface InitSurface(
			#if defined(MK_GLASS_FWD_BASE_PASS) || defined(MK_GLASS_FWD_ADD_PASS)
				in VertexOutputForward o
			#endif
		)
		{
			//Init Surface
			MKGlassSurface mkts;
			UNITY_INITIALIZE_OUTPUT(MKGlassSurface,mkts);

			//get refraction coords
			#if MKGLASS_TBN
				mkts.Pcp.UvRefraction = float4(o.uv_Main.zw, o.normalWorld.w, o.tangentWorld.w);
			#elif MKGLASS_WN
				mkts.Pcp.UvRefraction = o.uv_Refraction;
			#endif

			#if MKGLASS_DISTORTION
				half zF;
				#ifdef UNITY_Z_0_FAR_FROM_CLIPSPACE
					zF = UNITY_Z_0_FAR_FROM_CLIPSPACE(mkts.Pcp.UvRefraction.z);
				#else
					zF = mkts.Pcp.UvRefraction.z;
				#endif
				half4 texelSize;
				
				/*
				#if FAST_MODE	
					texelSize = _MKGlassRefraction_TexelSize;
				#else
					texelSize = _GrabTexture_TexelSize;
				#endif
				*/
				
				texelSize.xyzw = 0.00125;
			#endif

			//Unpack Occlusion
			#if MKGLASS_OCCLUSION
				half oms = 1.0 - _OcclusionStrength;
				mkts.Occlusion = mkts.Occlusion = oms + tex2D(_OcclusionMap, o.uv_Main).g * _OcclusionStrength;
			#endif

			#if MKGLASS_TC_D
				#if MKGLASS_TBN
					mkts.Pcp.UvDetail = float2(o.posWorld.w, o.binormalWorld.w);
				#elif MKGLASS_WN
					mkts.Pcp.UvDetail = o.uv_Detail;
				#endif
			#endif

			#if _MK_BUMP_MAP
				half3 encodedNormalMap = EncodeNormalMap(_BumpMap, o.uv_Main);
			#endif

			#if _MK_DETAIL_BUMP_MAP
				half3 encodedDetailNormalMap = EncodeNormalMap(_DetailNormalMap, mkts.Pcp.UvDetail);
			#endif

			//get normal direction
			#if MKGLASS_TBN
				//use default world normals if no bump is set
				#if !_MK_BUMP_MAP && !_MK_DETAIL_BUMP_MAP
					mkts.Pcp.NormalDirection = mkts.Pcp.RNormalDirection = normalize(o.normalWorld.xyz);
				#endif

				//NormalMap extraction
				#if _MK_BUMP_MAP
					mkts.Pcp.NormalDirection = WorldNormal(encodedNormalMap, _BumpScale, half3x3(o.tangentWorld.xyz, o.binormalWorld.xyz, o.normalWorld.xyz));
					mkts.Pcp.RNormalDirection =  WorldNormal(encodedNormalMap, _BumpScale*0.05, half3x3(o.tangentWorld.xyz, o.binormalWorld.xyz, o.normalWorld.xyz));
				#endif
				
				//detail NormalMap extraction
				#if _MK_DETAIL_BUMP_MAP
					mkts.Pcp.DetailNormalDirection  = WorldNormal(encodedDetailNormalMap, _DetailNormalMapScale, half3x3(o.tangentWorld.xyz, o.binormalWorld.xyz, o.normalWorld.xyz));
					mkts.Pcp.RDetailNormalDirection  = WorldNormal(encodedDetailNormalMap, _DetailNormalMapScale*0.05, half3x3(o.tangentWorld.xyz, o.binormalWorld.xyz, o.normalWorld.xyz));
				#endif

				//mixing of normals and setup distortion
				#if _MK_BUMP_MAP && _MK_DETAIL_BUMP_MAP
					mkts.Pcp.NormalDirection = lerp(mkts.Pcp.NormalDirection, mkts.Pcp.DetailNormalDirection, 0.5);
					mkts.Pcp.RNormalDirection = lerp(mkts.Pcp.RNormalDirection, mkts.Pcp.RDetailNormalDirection, 0.5);
					half3 lerpedencodedNormalMap = lerp(encodedNormalMap.xyz, encodedDetailNormalMap.xyz, 0.5);
					#if MKGLASS_DISTORTION
						half2 offsetN = SHINE_MULTXX * lerpedencodedNormalMap.xy * _Distortion * texelSize.xy;
					#endif
				#elif !_MK_BUMP_MAP && _MK_DETAIL_BUMP_MAP
					//if no default NormalMap is set use the detail normals
					mkts.Pcp.NormalDirection = mkts.Pcp.DetailNormalDirection;
					mkts.Pcp.RNormalDirection = mkts.Pcp.RDetailNormalDirection;
					#if MKGLASS_DISTORTION
						half2 offsetN = SHINE_MULTXX * encodedDetailNormalMap.xy * _Distortion * texelSize.xy;
					#endif
				#elif _MK_BUMP_MAP && !_MK_DETAIL_BUMP_MAP
					#if MKGLASS_DISTORTION
						half2 offsetN = SHINE_MULTXX * encodedNormalMap.xy * _Distortion * texelSize.xy;
					#endif
				#endif
				#if MKGLASS_DISTORTION
					mkts.Pcp.UvRefraction.xy = offsetN * zF + mkts.Pcp.UvRefraction.xy;
				#endif
			#elif MKGLASS_WN
				//basic normal input
				mkts.Pcp.NormalDirection = mkts.Pcp.RNormalDirection = normalize(o.normalWorld.xyz);
				#if MKGLASS_DISTORTION
					mkts.Pcp.UvRefraction.xy = offsetN * zF + mkts.Pcp.UvRefraction.xy;
				#endif
			#endif

			//init albedo surface color
			#if MKGLASS_TEXCLR
				SurfaceAlbedo(mkts.Color_Albedo, mkts.Alpha, o.uv_Main);
			#elif MKGLASS_VERTCLR
				SurfaceAlbedo(mkts.Color_Albedo, mkts.Alpha, o.color);
			#endif
			
			#if _MK_DETAIL_MAP
				//init detail albedo color
				SurfaceDetail(mkts.Color_DetailAlbedo, mkts.Pcp.UvDetail);
			#endif

			//init refraction color
			SurfaceRefraction(mkts.Color_Refraction, mkts.Pcp.UvRefraction);

			//mixing albedo, detail and refraction together
			#if _MK_ALBEDO_MAP && !_MK_DETAIL_MAP
				MixAlbedoRefraction(mkts.Color_Albedo, mkts.Color_Refraction, _MainTint);
			#elif !_MK_ALBEDO_MAP && _MK_DETAIL_MAP
				MixDetailRefraction(mkts.Color_DetailAlbedo, mkts.Color_Refraction, _DetailTint);
				mkts.Color_Albedo = mkts.Color_DetailAlbedo;
			#elif _MK_ALBEDO_MAP && _MK_DETAIL_MAP
				MixAlbedoDetailRefraction(mkts.Color_Albedo, mkts.Color_DetailAlbedo, mkts.Color_Refraction, _MainTint, _DetailTint);
			#else
				MixAlbedoRefraction(mkts.Color_Albedo, mkts.Color_Refraction, _MainTint);
			#endif

			//apply alpha 
			mkts.Color_Out.a = mkts.Alpha;

			#if MKGLASS_LIT
				#if MKGLASS_VD
					//view direction
					mkts.Pcp.ViewDirection = normalize(_WorldSpaceCameraPos - o.posWorld).xyz;
				#endif

				//lightdirection and attenuation
				#ifndef USING_DIRECTIONAL_LIGHT
					mkts.Pcp.LightDirection  = normalize(_WorldSpaceLightPos0.xyz - o.posWorld.xyz);
				#else
					mkts.Pcp.LightDirection = normalize(_WorldSpaceLightPos0.xyz);
				#endif

				UNITY_LIGHT_ATTENUATION(atten, o, o.posWorld.xyz);
				mkts.Pcp.LightAttenuation = atten;
				mkts.Pcp.LightColor = _LightColor0.rgb;
				mkts.Pcp.LightColorXAttenuation = mkts.Pcp.LightColor * mkts.Pcp.LightAttenuation;

				//init precalc
				#if MKGLASS_PRECALC
					PreCalcParameters(mkts);
				#endif
			#endif

			#if MKGLASS_LIT
				#if MKGLASS_TLM
					//get translucent intensity using map
					mkts.Color_Translucent = tex2D(_TranslucentMap, o.uv_Main).rg;
				#elif MKGLASS_TLD
					mkts.Color_Translucent = 1.0;
				#endif

				#if _MK_LIGHTMODEL_PHONG || _MK_LIGHTMODEL_BLINN_PHONG
					// get specular gloss, intensity
					#if _MK_SPECULAR_MAP
						mkts.Color_Specular = tex2D(_SpecGlossMap, o.uv_Main).rgb;
					#else
						mkts.Color_Specular = 1.0;
					#endif
				#endif

				#if _MKGLASS_REFLECTIVE
					mkts.Color_Reflect = GetReflection(mkts.Pcp.MVrefN, o.posWorld.xyz); //*= mkts.Pcp.LightAttenuation;
				#endif

				//apply emission color using a map
				#if MKGLASS_LIT
					#if _MKGLASS_EMISSION
						#if _MK_EMISSION_DEFAULT
							mkts.Color_Emission = _EmissionColor * mkts.Color_Albedo;
						#elif _MK_EMISSION_MAP
							mkts.Color_Emission = _EmissionColor * tex2D(_EmissionMap, o.uv_Main).rgb * mkts.Color_Albedo;
						#endif
					#endif
				#endif
			#endif
			return mkts;
		}
	#endif
#endif
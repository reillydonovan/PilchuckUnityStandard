/*
                                            _
   _ __ __ _ _   _ _ __ ___   __ _ _ __ ___| |__ (_)_ __   __ _ 
  | '__/ _` | | | | '_ ` _ \ /  ` | '__/ __| '_ \| | '_ \ /  ` |
  | | | (_| | |_| | | | | | |     | | | (__| | | | | | | |     |
  |_|  \__,_|\__, |_| |_| |_|\__,_|_|  \___|_| |_|_|_| |_|\__, |
             |___/                                        |___/ 
   _              _ _    _ _   
  | |_ ___   ___ | | | _(_) |_ 
  | __/   \ /   \| | |/ / | __|
  | ||     |     | |   <| | |_   for Unity
   \__\___/ \___/|_|_|\_\_|\__|
                              

  This shader was automatically generated from
  Raymarching Toolkit\Assets\Shaders\RaymarchTemplate.shader
  
  for Raymarcher named 'Raymarcher' in scene 'Character Creator'.

*/


Shader "Hidden/_Character Creator_1037335880.generated"
{

SubShader
{

Tags {
	"RenderType" = "Opaque"
	"Queue" = "Geometry-1"
	"DisableBatching" = "True"
	"IgnoreProjector" = "True"
}

Cull Off
ZWrite On

Pass
{

CGPROGRAM

#pragma shader_feature RENDER_OBJECT

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc" // @noinlineinclude
#if RENDER_OBJECT
#include "UnityPBSLighting.cginc" // @noinlineinclude
#endif

// #define DEBUG_STEPS 1
// #define DEBUG_MATERIALS 1
// #define AO_ENABLED 1
// #define FOG_ENABLED 1
// #define FADE_TO_SKYBOX 1

#ifdef _RAYMARCHING_CGINC
#error "Already included Raymarching.cginc"
#else
#define _RAYMARCHING_CGINC 1

//
// Noise Shader Library for Unity - https://github.com/keijiro/NoiseShader
//
// Original work (webgl-noise) Copyright (C) 2011 Stefan Gustavson
// Translation and modification was made by Keijiro Takahashi.
//
// This shader is based on the webgl-noise GLSL shader. For further details
// of the original shader, please see the following description from the
// original source code.
//

//
// GLSL textureless classic 2D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//


float3 mod(float3 x, float3 y)
{
  return x - y * floor(x / y);
}
float4 mod(float4 x, float4 y)
{
  return x - y * floor(x / y);
}

float2 mod289(float2 x)
{
    return x - floor(x / 289.0) * 289.0;
}
float3 mod289(float3 x)
{
  return x - floor(x / 289.0) * 289.0;
}
float4 mod289(float4 x)
{
  return x - floor(x / 289.0) * 289.0;
}

float3 permute(float3 x)
{
    return mod289((x * 34.0 + 1.0) * x);
}
float4 permute(float4 x)
{
  return mod289(((x*34.0)+1.0)*x);
}

float3 taylorInvSqrt(float3 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}
float4 taylorInvSqrt(float4 r)
{
  return (float4)1.79284291400159 - r * 0.85373472095314;
}

float2 fade(float2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}
float3 fade(float3 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

// Classic Perlin noise
float cnoise(float2 P)
{
  float4 Pi = floor(P.xyxy) + float4(0.0, 0.0, 1.0, 1.0);
  float4 Pf = frac (P.xyxy) - float4(0.0, 0.0, 1.0, 1.0);
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  float4 ix = Pi.xzxz;
  float4 iy = Pi.yyww;
  float4 fx = Pf.xzxz;
  float4 fy = Pf.yyww;

  float4 i = permute(permute(ix) + iy);

  float4 gx = frac(i / 41.0) * 2.0 - 1.0 ;
  float4 gy = abs(gx) - 0.5 ;
  float4 tx = floor(gx + 0.5);
  gx = gx - tx;

  float2 g00 = float2(gx.x,gy.x);
  float2 g10 = float2(gx.y,gy.y);
  float2 g01 = float2(gx.z,gy.z);
  float2 g11 = float2(gx.w,gy.w);

  float4 norm = taylorInvSqrt(float4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;

  float n00 = dot(g00, float2(fx.x, fy.x));
  float n10 = dot(g10, float2(fx.y, fy.y));
  float n01 = dot(g01, float2(fx.z, fy.z));
  float n11 = dot(g11, float2(fx.w, fy.w));

  float2 fade_xy = fade(Pf.xy);
  float2 n_x = lerp(float2(n00, n01), float2(n10, n11), fade_xy.x);
  float n_xy = lerp(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

// Classic Perlin noise, periodic variant
float pnoise(float2 P, float2 rep)
{
  float4 Pi = floor(P.xyxy) + float4(0.0, 0.0, 1.0, 1.0);
  float4 Pf = frac (P.xyxy) - float4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, rep.xyxy); // To create noise with explicit period
  Pi = mod289(Pi);        // To avoid truncation effects in permutation
  float4 ix = Pi.xzxz;
  float4 iy = Pi.yyww;
  float4 fx = Pf.xzxz;
  float4 fy = Pf.yyww;

  float4 i = permute(permute(ix) + iy);

  float4 gx = frac(i / 41.0) * 2.0 - 1.0 ;
  float4 gy = abs(gx) - 0.5 ;
  float4 tx = floor(gx + 0.5);
  gx = gx - tx;

  float2 g00 = float2(gx.x,gy.x);
  float2 g10 = float2(gx.y,gy.y);
  float2 g01 = float2(gx.z,gy.z);
  float2 g11 = float2(gx.w,gy.w);

  float4 norm = taylorInvSqrt(float4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;

  float n00 = dot(g00, float2(fx.x, fy.x));
  float n10 = dot(g10, float2(fx.y, fy.y));
  float n01 = dot(g01, float2(fx.z, fy.z));
  float n11 = dot(g11, float2(fx.w, fy.w));

  float2 fade_xy = fade(Pf.xy);
  float2 n_x = lerp(float2(n00, n01), float2(n10, n11), fade_xy.x);
  float n_xy = lerp(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}



// Classic Perlin noise
float cnoise(float3 P)
{
  float3 Pi0 = floor(P); // Integer part for indexing
  float3 Pi1 = Pi0 + (float3)1.0; // Integer part + 1
  Pi0 = mod289(Pi0);
  Pi1 = mod289(Pi1);
  float3 Pf0 = frac(P); // Fractional part for interpolation
  float3 Pf1 = Pf0 - (float3)1.0; // Fractional part - 1.0
  float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  float4 iy = float4(Pi0.y, Pi0.y, Pi1.y, Pi1.y);
  float4 iz0 = (float4)Pi0.z;
  float4 iz1 = (float4)Pi1.z;

  float4 ixy = permute(permute(ix) + iy);
  float4 ixy0 = permute(ixy + iz0);
  float4 ixy1 = permute(ixy + iz1);

  float4 gx0 = ixy0 / 7.0;
  float4 gy0 = frac(floor(gx0) / 7.0) - 0.5;
  gx0 = frac(gx0);
  float4 gz0 = (float4)0.5 - abs(gx0) - abs(gy0);
  float4 sz0 = step(gz0, (float4)0.0);
  gx0 -= sz0 * (step((float4)0.0, gx0) - 0.5);
  gy0 -= sz0 * (step((float4)0.0, gy0) - 0.5);

  float4 gx1 = ixy1 / 7.0;
  float4 gy1 = frac(floor(gx1) / 7.0) - 0.5;
  gx1 = frac(gx1);
  float4 gz1 = (float4)0.5 - abs(gx1) - abs(gy1);
  float4 sz1 = step(gz1, (float4)0.0);
  gx1 -= sz1 * (step((float4)0.0, gx1) - 0.5);
  gy1 -= sz1 * (step((float4)0.0, gy1) - 0.5);

  float3 g000 = float3(gx0.x,gy0.x,gz0.x);
  float3 g100 = float3(gx0.y,gy0.y,gz0.y);
  float3 g010 = float3(gx0.z,gy0.z,gz0.z);
  float3 g110 = float3(gx0.w,gy0.w,gz0.w);
  float3 g001 = float3(gx1.x,gy1.x,gz1.x);
  float3 g101 = float3(gx1.y,gy1.y,gz1.y);
  float3 g011 = float3(gx1.z,gy1.z,gz1.z);
  float3 g111 = float3(gx1.w,gy1.w,gz1.w);

  float4 norm0 = taylorInvSqrt(float4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
  g000 *= norm0.x;
  g010 *= norm0.y;
  g100 *= norm0.z;
  g110 *= norm0.w;

  float4 norm1 = taylorInvSqrt(float4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
  g001 *= norm1.x;
  g011 *= norm1.y;
  g101 *= norm1.z;
  g111 *= norm1.w;

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, float3(Pf1.x, Pf0.y, Pf0.z));
  float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, float3(Pf1.x, Pf1.y, Pf0.z));
  float n001 = dot(g001, float3(Pf0.x, Pf0.y, Pf1.z));
  float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, float3(Pf0.x, Pf1.y, Pf1.z));
  float n111 = dot(g111, Pf1);

  float3 fade_xyz = fade(Pf0);
  float4 n_z = lerp(float4(n000, n100, n010, n110), float4(n001, n101, n011, n111), fade_xyz.z);
  float2 n_yz = lerp(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = lerp(n_yz.x, n_yz.y, fade_xyz.x);
  return 2.2 * n_xyz;
}

// Classic Perlin noise, periodic variant
float pnoise(float3 P, float3 rep)
{
  float3 Pi0 = mod(floor(P), rep); // Integer part, modulo period
  float3 Pi1 = mod(Pi0 + (float3)1.0, rep); // Integer part + 1, mod period
  Pi0 = mod289(Pi0);
  Pi1 = mod289(Pi1);
  float3 Pf0 = frac(P); // Fractional part for interpolation
  float3 Pf1 = Pf0 - (float3)1.0; // Fractional part - 1.0
  float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  float4 iy = float4(Pi0.y, Pi0.y, Pi1.y, Pi1.y);
  float4 iz0 = (float4)Pi0.z;
  float4 iz1 = (float4)Pi1.z;

  float4 ixy = permute(permute(ix) + iy);
  float4 ixy0 = permute(ixy + iz0);
  float4 ixy1 = permute(ixy + iz1);

  float4 gx0 = ixy0 / 7.0;
  float4 gy0 = frac(floor(gx0) / 7.0) - 0.5;
  gx0 = frac(gx0);
  float4 gz0 = (float4)0.5 - abs(gx0) - abs(gy0);
  float4 sz0 = step(gz0, (float4)0.0);
  gx0 -= sz0 * (step((float4)0.0, gx0) - 0.5);
  gy0 -= sz0 * (step((float4)0.0, gy0) - 0.5);

  float4 gx1 = ixy1 / 7.0;
  float4 gy1 = frac(floor(gx1) / 7.0) - 0.5;
  gx1 = frac(gx1);
  float4 gz1 = (float4)0.5 - abs(gx1) - abs(gy1);
  float4 sz1 = step(gz1, (float4)0.0);
  gx1 -= sz1 * (step((float4)0.0, gx1) - 0.5);
  gy1 -= sz1 * (step((float4)0.0, gy1) - 0.5);

  float3 g000 = float3(gx0.x,gy0.x,gz0.x);
  float3 g100 = float3(gx0.y,gy0.y,gz0.y);
  float3 g010 = float3(gx0.z,gy0.z,gz0.z);
  float3 g110 = float3(gx0.w,gy0.w,gz0.w);
  float3 g001 = float3(gx1.x,gy1.x,gz1.x);
  float3 g101 = float3(gx1.y,gy1.y,gz1.y);
  float3 g011 = float3(gx1.z,gy1.z,gz1.z);
  float3 g111 = float3(gx1.w,gy1.w,gz1.w);

  float4 norm0 = taylorInvSqrt(float4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
  g000 *= norm0.x;
  g010 *= norm0.y;
  g100 *= norm0.z;
  g110 *= norm0.w;
  float4 norm1 = taylorInvSqrt(float4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
  g001 *= norm1.x;
  g011 *= norm1.y;
  g101 *= norm1.z;
  g111 *= norm1.w;

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, float3(Pf1.x, Pf0.y, Pf0.z));
  float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, float3(Pf1.x, Pf1.y, Pf0.z));
  float n001 = dot(g001, float3(Pf0.x, Pf0.y, Pf1.z));
  float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, float3(Pf0.x, Pf1.y, Pf1.z));
  float n111 = dot(g111, Pf1);

  float3 fade_xyz = fade(Pf0);
  float4 n_z = lerp(float4(n000, n100, n010, n110), float4(n001, n101, n011, n111), fade_xyz.z);
  float2 n_yz = lerp(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = lerp(n_yz.x, n_yz.y, fade_xyz.x);
  return 2.2 * n_xyz;
}

float snoise(float2 v)
{
    const float4 C = float4( 0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                             0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                            -0.577350269189626,  // -1.0 + 2.0 * C.x
                             0.024390243902439); // 1.0 / 41.0
    // First corner
    float2 i  = floor(v + dot(v, C.yy));
    float2 x0 = v -   i + dot(i, C.xx);

    // Other corners
    float2 i1;
    i1.x = step(x0.y, x0.x);
    i1.y = 1.0 - i1.x;

    // x1 = x0 - i1  + 1.0 * C.xx;
    // x2 = x0 - 1.0 + 2.0 * C.xx;
    float2 x1 = x0 + C.xx - i1;
    float2 x2 = x0 + C.zz;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    float3 p =
      permute(permute(i.y + float3(0.0, i1.y, 1.0))
                    + i.x + float3(0.0, i1.x, 1.0));

    float3 m = max(0.5 - float3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0.0);
    m = m * m;
    m = m * m;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    float3 x = 2.0 * frac(p * C.www) - 1.0;
    float3 h = abs(x) - 0.5;
    float3 ox = floor(x + 0.5);
    float3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    m *= taylorInvSqrt(a0 * a0 + h * h);

    // Compute final noise value at P
    float3 g;
    g.x = a0.x * x0.x + h.x * x0.y;
    g.y = a0.y * x1.x + h.y * x1.y;
    g.z = a0.z * x2.x + h.z * x2.y;
    return 130.0 * dot(m, g);
}


float snoise(float3 v)
{
    const float2 C = float2(1.0 / 6.0, 1.0 / 3.0);

    // First corner
    float3 i  = floor(v + dot(v, C.yyy));
    float3 x0 = v   - i + dot(i, C.xxx);

    // Other corners
    float3 g = step(x0.yzx, x0.xyz);
    float3 l = 1.0 - g;
    float3 i1 = min(g.xyz, l.zxy);
    float3 i2 = max(g.xyz, l.zxy);

    // x1 = x0 - i1  + 1.0 * C.xxx;
    // x2 = x0 - i2  + 2.0 * C.xxx;
    // x3 = x0 - 1.0 + 3.0 * C.xxx;
    float3 x1 = x0 - i1 + C.xxx;
    float3 x2 = x0 - i2 + C.yyy;
    float3 x3 = x0 - 0.5;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    float4 p =
      permute(permute(permute(i.z + float4(0.0, i1.z, i2.z, 1.0))
                            + i.y + float4(0.0, i1.y, i2.y, 1.0))
                            + i.x + float4(0.0, i1.x, i2.x, 1.0));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float4 j = p - 49.0 * floor(p / 49.0);  // mod(p,7*7)

    float4 x_ = floor(j / 7.0);
    float4 y_ = floor(j - 7.0 * x_);  // mod(j,N)

    float4 x = (x_ * 2.0 + 0.5) / 7.0 - 1.0;
    float4 y = (y_ * 2.0 + 0.5) / 7.0 - 1.0;

    float4 h = 1.0 - abs(x) - abs(y);

    float4 b0 = float4(x.xy, y.xy);
    float4 b1 = float4(x.zw, y.zw);

    //float4 s0 = float4(lessThan(b0, 0.0)) * 2.0 - 1.0;
    //float4 s1 = float4(lessThan(b1, 0.0)) * 2.0 - 1.0;
    float4 s0 = floor(b0) * 2.0 + 1.0;
    float4 s1 = floor(b1) * 2.0 + 1.0;
    float4 sh = -step(h, 0.0);

    float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

    float3 g0 = float3(a0.xy, h.x);
    float3 g1 = float3(a0.zw, h.y);
    float3 g2 = float3(a1.xy, h.z);
    float3 g3 = float3(a1.zw, h.w);

    // Normalise gradients
    float4 norm = taylorInvSqrt(float4(dot(g0, g0), dot(g1, g1), dot(g2, g2), dot(g3, g3)));
    g0 *= norm.x;
    g1 *= norm.y;
    g2 *= norm.z;
    g3 *= norm.w;

    // Mix final noise value
    float4 m = max(0.6 - float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
    m = m * m;
    m = m * m;

    float4 px = float4(dot(x0, g0), dot(x1, g1), dot(x2, g2), dot(x3, g3));
    return 42.0 * dot(m, px);
}



float2 snoise_grad(float2 v)
{
    const float4 C = float4( 0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                             0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                            -0.577350269189626,  // -1.0 + 2.0 * C.x
                             0.024390243902439); // 1.0 / 41.0
    // First corner
    float2 i  = floor(v + dot(v, C.yy));
    float2 x0 = v -   i + dot(i, C.xx);

    // Other corners
    float2 i1;
    i1.x = step(x0.y, x0.x);
    i1.y = 1.0 - i1.x;

    // x1 = x0 - i1  + 1.0 * C.xx;
    // x2 = x0 - 1.0 + 2.0 * C.xx;
    float2 x1 = x0 + C.xx - i1;
    float2 x2 = x0 + C.zz;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    float3 p =
      permute(permute(i.y + float3(0.0, i1.y, 1.0))
                    + i.x + float3(0.0, i1.x, 1.0));

    float3 m = max(0.5 - float3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0.0);
    float3 m2 = m * m;
    float3 m3 = m2 * m;
    float3 m4 = m2 * m2;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    float3 x = 2.0 * frac(p * C.www) - 1.0;
    float3 h = abs(x) - 0.5;
    float3 ox = floor(x + 0.5);
    float3 a0 = x - ox;

    // Normalise gradients
    float3 norm = taylorInvSqrt(a0 * a0 + h * h);
    float2 g0 = float2(a0.x, h.x) * norm.x;
    float2 g1 = float2(a0.y, h.y) * norm.y;
    float2 g2 = float2(a0.z, h.z) * norm.z;

    // Compute gradient of noise function at P
    float2 grad =
      -6.0 * m3.x * x0 * dot(x0, g0) + m4.x * g0 +
      -6.0 * m3.y * x1 * dot(x1, g1) + m4.y * g1 +
      -6.0 * m3.z * x2 * dot(x2, g2) + m4.z * g2;
    return 130.0 * grad;
}



float3 snoise_grad(float3 v)
{
    const float2 C = float2(1.0 / 6.0, 1.0 / 3.0);

    // First corner
    float3 i  = floor(v + dot(v, C.yyy));
    float3 x0 = v   - i + dot(i, C.xxx);

    // Other corners
    float3 g = step(x0.yzx, x0.xyz);
    float3 l = 1.0 - g;
    float3 i1 = min(g.xyz, l.zxy);
    float3 i2 = max(g.xyz, l.zxy);

    // x1 = x0 - i1  + 1.0 * C.xxx;
    // x2 = x0 - i2  + 2.0 * C.xxx;
    // x3 = x0 - 1.0 + 3.0 * C.xxx;
    float3 x1 = x0 - i1 + C.xxx;
    float3 x2 = x0 - i2 + C.yyy;
    float3 x3 = x0 - 0.5;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    float4 p =
      permute(permute(permute(i.z + float4(0.0, i1.z, i2.z, 1.0))
                            + i.y + float4(0.0, i1.y, i2.y, 1.0))
                            + i.x + float4(0.0, i1.x, i2.x, 1.0));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float4 j = p - 49.0 * floor(p / 49.0);  // mod(p,7*7)

    float4 x_ = floor(j / 7.0);
    float4 y_ = floor(j - 7.0 * x_);  // mod(j,N)

    float4 x = (x_ * 2.0 + 0.5) / 7.0 - 1.0;
    float4 y = (y_ * 2.0 + 0.5) / 7.0 - 1.0;

    float4 h = 1.0 - abs(x) - abs(y);

    float4 b0 = float4(x.xy, y.xy);
    float4 b1 = float4(x.zw, y.zw);

    //float4 s0 = float4(lessThan(b0, 0.0)) * 2.0 - 1.0;
    //float4 s1 = float4(lessThan(b1, 0.0)) * 2.0 - 1.0;
    float4 s0 = floor(b0) * 2.0 + 1.0;
    float4 s1 = floor(b1) * 2.0 + 1.0;
    float4 sh = -step(h, 0.0);

    float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

    float3 g0 = float3(a0.xy, h.x);
    float3 g1 = float3(a0.zw, h.y);
    float3 g2 = float3(a1.xy, h.z);
    float3 g3 = float3(a1.zw, h.w);

    // Normalise gradients
    float4 norm = taylorInvSqrt(float4(dot(g0, g0), dot(g1, g1), dot(g2, g2), dot(g3, g3)));
    g0 *= norm.x;
    g1 *= norm.y;
    g2 *= norm.z;
    g3 *= norm.w;

    // Compute gradient of noise function at P
    float4 m = max(0.6 - float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
    float4 m2 = m * m;
    float4 m3 = m2 * m;
    float4 m4 = m2 * m2;
    float3 grad =
      -6.0 * m3.x * x0 * dot(x0, g0) + m4.x * g0 +
      -6.0 * m3.y * x1 * dot(x1, g1) + m4.y * g1 +
      -6.0 * m3.z * x2 * dot(x2, g2) + m4.z * g2 +
      -6.0 * m3.w * x3 * dot(x3, g3) + m4.w * g3;
    return 42.0 * grad;
}

#define PI 3.1415926535897932384626433832795
#define INFINITY 1e6
#define PHI (sqrt(5)*0.5 + 0.5)
#define deg2rad 0.0174533

#ifndef USE_OPTIMIZED_NORMAL
#define USE_OPTIMIZED_NORMAL 1
#endif


uniform float _DrawDistance = 1000;
uniform float _Steps = 64;
uniform float ConservativeStepFactor = 1;

float3 getLights(in float3 color, in float3 pos, in float3 normal);
float2 map(float3 p);

float compute_depth(float4 clippos) {
#if defined(UNITY_REVERSED_Z)
	return clippos.z / clippos.w;
#else
  return ((clippos.z / clippos.w) + 1.0) * 0.5;
#endif
}

float3 calcNormal(in float3 pos)
{
	#if USE_OPTIMIZED_NORMAL
    const float2 e = float2(1.0,-1.0)*0.5773*0.0005;
    return normalize(
            e.xyy*map( pos + e.xyy ).x + 
					  e.yyx*map( pos + e.yyx ).x + 
					  e.yxy*map( pos + e.yxy ).x + 
					  e.xxx*map( pos + e.xxx ).x );
	#else
	float3 eps = float3(0.0005, 0.0, 0.0);
	float3 nor = float3(
	    map(pos+eps.xyy).x - map(pos-eps.xyy).x,
	    map(pos+eps.yxy).x - map(pos-eps.yxy).x,
	    map(pos+eps.yyx).x - map(pos-eps.yyx).x );
	return normalize(nor);
	#endif	
}


float  modc(float  a, float  b) { return a - b * floor(a/b); }
float2 modc(float2 a, float2 b) { return a - b * floor(a/b); }
float3 modc(float3 a, float3 b) { return a - b * floor(a/b); }
float4 modc(float4 a, float4 b) { return a - b * floor(a/b); }

float lengthn(float2 p, int n) { return pow(pow(p.x, n) + pow(p.y, n), 1. / n); }
float lengthn(float3 p, int n) { return pow(pow(p.x, n) + pow(p.y, n) + pow(p.z, n), 1. / n); }

// returns float3(radius, theta, phi) from float3(x, y, z)
float3 toSpherical(float3 p) {
  float radius = length(p);
  return float3(
    radius,
    acos(p.z / radius), 
    atan2(p.y, p.x));
}

// return float3(x, y, z) from float3(radius, theta, phi)
float3 fromSpherical(float3 sphericalCoords) {
  return float3(
    sphericalCoords.x * sin(sphericalCoords.y) * cos(sphericalCoords.z),
    sphericalCoords.x * sin(sphericalCoords.y) * sin(sphericalCoords.z),
    sphericalCoords.x * cos(sphericalCoords.y)
  );
}

float udRoundBox(float3 p, float3 b, float r)
{
	return length(max(abs(p) - b, 0.0)) - r;
}

float sdEllipsoid(in float3 p, in float3 r)
{
    return (length(p/r) - 1.0) * min(min(r.x, r.y), r.z);
}

float3 rotateX(float3 p, float angle)
{
    float c = cos(angle);
    float s = sin(angle);
    return float3(p.x, c*p.y+s*p.z, -s*p.y+c*p.z);
}

float3 rotateY(float3 p, float angle)
{
    float c = cos(angle);
    float s = sin(angle);
    return float3(c*p.x-s*p.z, p.y, s*p.x+c*p.z);
}

float3 rotateZ(float3 p, float angle)
{
    float c = cos(angle);
    float s = sin(angle);
    return float3(c*p.x+s*p.y, -s*p.x+c*p.y, p.z);
}

float3 processColor(float2 hit, float3 raypos, float3 dir);


// OPERATIONS

float opSubtract(float d1, float d2) {
	return max(-d1, d2);
}

float2 opSubtract(float d1, float2 d2) {
  return float2(max(-d1.x, d2.x), d2.y);
}

float opIntersect(float d1, float d2) {
	return max(d1, d2);
}
// REPETITION, returns modified p to be used as primitive(newp)
float3 opRep(float3 p, float3 c)
{
	float3 q = modc(p, c) - c * 0.5;
	return q;
}

// UNION
float2 opU(float2 d1, float2 d2) {
	return (d1.x < d2.x) ? d1 : d2;
}
float opU(float d1, float d2) {
	return (d1 < d2) ? d1 : d2;
}

float smin(float a, float b, float k) {
	float h = clamp(0.5 + 0.5*(b - a) / k, 0, 1);
	return lerp(b, a, h) - k*h*(1 - h);
}

float2 smin(float2 a, float2 b, float k) {
	float h = clamp(0.5 + 0.5*(b.x - a.x) / k, 0, 1);
	return lerp(b, a, h) - k*h*(1 - h);
}

float4 tex3D_2D(in float3 pos, in float3 normal, sampler2D tex) {
	return 	tex2Dlod(tex, float4(pos.y, pos.z, 0, 0)) * abs(normal.x) +
			tex2Dlod(tex, float4(pos.x, pos.z, 0, 0)) * abs(normal.y) +
			tex2Dlod(tex, float4(pos.x, pos.y, 0, 0)) * abs(normal.z);
}

// PRIMITIVES

// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
float box(float3 p, float3 size) {
  float3 d = abs(p)-size;
  float b = min(max(d.x, max(d.y,d.z)), 0) + length(max(d, 0));
  return b;
}
float3 sphere(float3 p, float r) {
  return length(p) - r;
}

float getGradientValue(sampler2D tex, float value) {
  return tex2Dlod(tex, float4(clamp(value,0,1),0,0,0)).r;
}
float getCurveValue(sampler2D tex, float value) {
  return tex2Dlod(tex, float4(clamp(value,0,1),0,0,0)).r;
}

// easing
// accelerating from zero velocity
float easeInQuad (float t) { return t*t; }
// decelerating to zero velocity
float easeOutQuad (float t) { return t*(2-t); }
// acceleration until halfway, then deceleration
float easeInOutQuad (float t) { return t<.5 ? 2*t*t : -1+(4-2*t)*t; }
// accelerating from zero velocity 
float easeInCubic (float t) { return t*t*t; }
// decelerating to zero velocity 
float easeOutCubic (float t) { return (--t)*t*t+1; }
// acceleration until halfway, then deceleration 
float easeInOutCubic (float t) { return t<.5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1; }
// accelerating from zero velocity 
float easeInQuart (float t) { return t*t*t*t; }
// decelerating to zero velocity 
float easeOutQuart (float t) { return 1-(--t)*t*t*t; }
// acceleration until halfway, then deceleration
float easeInOutQuart (float t) { return t<.5 ? 8*t*t*t*t : 1-8*(--t)*t*t*t; }
// accelerating from zero velocity
float easeInQuint (float t) { return t*t*t*t*t; }
// decelerating to zero velocity
float easeOutQuint (float t) { return 1+(--t)*t*t*t*t; }
// acceleration until halfway, then deceleration 
float easeInOutQuint (float t) { return t<.5 ? 16*t*t*t*t*t : 1+16*(--t)*t*t*t*t; }

// noise

// Pseudo-random number (from: lumina.sourceforge.net/Tutorials/Noise.html)
float rand(float2 co)
{
	return frac(cos(dot(co, float2(4.898, 7.23))) * 23421.631);
}

float get_camera_near_plane()
{
  return _ProjectionParams.y;
}

float omega = 1.2;

float2 simpleRaytrace(float3 ro, float3 rd, out float3 raypos, out int numSteps, inout bool found)
{
	const int maxstep = _Steps;
	float t = get_camera_near_plane();
	found = false;
	float2 d;

	[loop]
	for (numSteps = 0; numSteps < maxstep; ++numSteps)
	{
		// If we run past the depth buffer, or if we exceed the max draw distance,
		// stop and return nothing (transparent pixel).
		// this way raymarched objects and traditional meshes can coexist.
		if (t > _DrawDistance)
			break;

		raypos = ro + rd * t;   // World space position of sample
		d = map(raypos);		// Sample of distance field (see map())

		// If the sample <= 0, we have hit something (see map()).
		[branch]
		if (d.x < 0.001) {
			found = true;
			break;
		}

		t += d * ConservativeStepFactor;
	}
	
    return d;
}


#define RELAXATION 0

float2 trace(float3 o, float3 d, out float3 raypos, out int numSteps, inout bool found) {
  float t_min = get_camera_near_plane();
  float t_max = _DrawDistance - get_camera_near_plane();
  float t = t_min;
  float candidate_error = INFINITY;
  float candidate_t = t_min;
  float candidate_mat = 0;
  float previousRadius = 0;
  float stepLength = 0;
  float functionSign = map(o).x < 0 ? -1 : +1;
  float pixelRadius = .001; // _ScreenParams.z - 1.0;
  raypos = o;
  [loop]
  for (int i = 0; i < _Steps; ++i) {
    raypos = d * t + o;
    float2 hit = map(raypos);
    float signedRadius = functionSign * hit.x;
    float radius = abs(signedRadius);

    #if RELAXATION
    bool sorFail = omega > 1 && (radius + previousRadius) < stepLength;
    if (sorFail) {
      stepLength -= omega * stepLength;
      omega = 1;
    } else
      stepLength = signedRadius * omega;
    #else
      stepLength = signedRadius;
    #endif

    previousRadius = radius;
    float error = radius / t;
    if (
    #if RELAXATION
      !sorFail &&
    #endif
      error < candidate_error) {
      candidate_t = t;
      candidate_error = error;
      candidate_mat = hit.y;
    }

    [branch]
    if (
    #if RELAXATION
      !sorFail && 
    #endif
      error < pixelRadius || t > t_max)
    {
      found = true;
      break;
    }

    t += stepLength * ConservativeStepFactor;
    numSteps++;
  }

  if ((t > t_max || candidate_error > pixelRadius))
    found = false;
  else
    found = true;
  return float2(candidate_t, candidate_mat);
}
/*
 * lambert diffuse lighting model
 */

struct LightInput {
   float3 color;
   float3 pos;
   float3 normal;
};

struct LightInfo {
  float4 posAndRange;
  float4 colorAndIntensity;
  float3 direction;
};

float3 getDirectionalLight(in LightInput ray, in LightInfo light)
{
  float diffuse = max(0.0, dot(-ray.normal, light.direction)) * light.colorAndIntensity.a; // point w normal
  return diffuse * (light.colorAndIntensity.xyz * ray.color);
}

float3 getPointLight(in LightInput ray, in LightInfo light)
{
  float3 toLight = ray.pos - light.posAndRange.xyz;
  float range = clamp(length(toLight) / light.posAndRange.w, 0., 1.);
  float attenuation = 1.0 / (1.0 + 256.0 * range*range);     //http://forum.unity3d.com/threads/light-attentuation-equation.16006/
  float diffuse = max(0.0, dot(-ray.normal, normalize(toLight.xyz))) * light.colorAndIntensity.a * attenuation; // point w normal
  return diffuse * (light.colorAndIntensity.xyz * ray.color);
}

float3 getCelShadedPointLight(in LightInput ray, in LightInfo light)
{
  float3 toLight = ray.pos - light.posAndRange.xyz;
  float range = clamp(length(toLight) / light.posAndRange.w, 0., 1.);
  float attenuation = 1.0 / (1.0 + 256.0 * range*range);     //http://forum.unity3d.com/threads/light-attentuation-equation.16006/
  float diffuse = max(0.0, dot(-ray.normal, normalize(toLight.xyz))) * light.colorAndIntensity.a * attenuation; // point w normal
  diffuse = round(diffuse * 5) / 5;
  return diffuse * (light.colorAndIntensity.xyz * ray.color);
}

float3 getCelShadedDirectionalLight(in LightInput ray, in LightInfo light)
{
  float diffuse = max(0.0, dot(-ray.normal, light.direction)) * light.colorAndIntensity.a; // point w normal
  diffuse = round(diffuse * 5) / 5;
  return diffuse * (light.colorAndIntensity.xyz * ray.color);
}

float unlerpClamped(float ax, float a1, float a2) {
  return clamp(clamp(ax - a1, 0, 999999) / (a2 - a1), 0.0, 1.0);
}

// Repeat the "world" at p where "repeat" is the axes to repeat in.
// for example, to repeat every 1,1,1 cube in all directions, do repeatWorld(p, float3(1,1,1))
float3 repeatWorld(float3 p, float3 repeat) {
	return sign(p / repeat) * (p % repeat) - 0.5 * repeat;
}

float nrand(float2 uv)
{
    return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
}

float3 simplecolor(float4 settings) {
	return settings.xyz;
}

float3 stripePattern(float3 pos, float3 color1, float3 color2, float4 settings) {
	float a = (cos(
		(pos.y * settings.y) +
		(pos.z * settings.z) *
		(pos.x * settings.x))
		+ 1.) / 2.;
	a = modc(a + settings.w, 1.0f);
	return lerp(color1, color2, round(a));
}

float3 stripePattern2(float3 pos, float3 color1, float3 color2, float4 settings) {
  float a = (cos(
    (pos.y * settings.y) +
    (pos.z * settings.z) *
    (pos.x * settings.x))
    +1.) / 2.;
  a = modc(a + settings.w, 1.0f);
  return lerp(color1, color2, round(a));
}

float checkeredPattern(float3 p) {
  p *= 10.0;
      float u = 1.0 - floor(modc(p.x, 2.0));
  float v = 1.0 - floor(modc(p.y, 2.0));
  float w = 1.0 - floor(modc(p.z, 2.0));
  if ((u == 1.0 && v < 1.0) || (u < 1.0 && v == 1.0) || (v == 1.0 && w < 1.0) || (v < 1.0 && w == 1.0) || (u == 1.0 && w < 1.0) || (u < 1.0 && w == 1.0))
    return 0.5;
  else
    return 1.0;
}

float turbulence(float3 p, float size) {
  float value = 0.0, initialSize = size;
  while (size >= 1) {
    value += snoise(p/size) * size;
    size /= 2.0;
  }
  return (128.0 * value / initialSize);
}

float noise3d(float3 pos) {
  return clamp(turbulence(pos*200.0, 16.0)/32.0 * 2.0 + 0.5, 0., 1.);
}


//float3 MaterialFunc(float nf, float3 normal, float3 pos, float3 rayDir, out float objectID);
// float3 MaterialFunc(float nf, float3 normal, float3 pos, float3 rayDir, out float objectID) { objectID = 0; return float3(1, 0, 1); } // STUB

uniform float4 _AmbientColor;
uniform float AmbientOcclusion = 0;
uniform int AmbientOcclusionSteps = 8;

float3 TransformPoint(float4x4 mat, float3 pos) { return mul(mat, float4(pos.x, pos.y, pos.z, 1.0)).xyz; }
#define objPos TransformPoint

float ambientOcclusion(float3 p, float3 n) {
#define AO_DELTA 2
	float a = 0.0;
	float weight = AmbientOcclusion;
	for (int i = 1; i <= AmbientOcclusionSteps; i++) {
		float d = (float(i) / float(AmbientOcclusionSteps)) * AO_DELTA; 
		a += weight * (d - map(p + n * d));
		weight *= 0.5;
	}
	return saturate(1.0 - a);
}

float hardshadow(in float3 ro, in float3 rd, float maxt, int ShadowSteps)
{
    float mint = 0.05f;
    float t = mint;
    for (int i = 0; i < ShadowSteps; ++i)
    {
        if (t >= maxt) break;
        float h = map(ro + rd*t);
        if (h < 0.001)
            return 0.0;
        t += h;
    }
    return 1.0;
}

float softshadow(in float3 ro, in float3 rd, float maxt, float k, int ShadowSteps) {
	float mint = 0.05;
	float res = 1.0;
	float t = mint;
	for (int i = 0; i < ShadowSteps; ++i) {
		if (t >= maxt) break;
		float h = map(ro + rd*t);
		if (h < 0.002) return 0.0;
		res = min(res, k*h / t);
		t += h;
	}
	return res;
}

struct vertexFSTriangleInput
{
	float4 vertex : POSITION;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

#if RENDER_OBJECT
struct v2f
{
    float4 pos         : SV_POSITION;
    float4 screenPos   : TEXCOORD0;
    float4 worldPos    : TEXCOORD1;
	UNITY_VERTEX_INPUT_INSTANCE_ID
	UNITY_VERTEX_OUTPUT_STEREO
};
#else
struct v2f
{
	float4 vertex : SV_POSITION;
	float4 interpolatedRay : TEXCOORD0; 
	UNITY_VERTEX_INPUT_INSTANCE_ID
	UNITY_VERTEX_OUTPUT_STEREO
};
#endif

uniform float4x4 _FrustumCornersWS;
#if UNITY_SINGLE_PASS_STEREO
uniform float4x4 _FrustumCornersWS2;
#endif

v2f vert(vertexFSTriangleInput input)
{
	v2f o;
    UNITY_SETUP_INSTANCE_ID(input);
    UNITY_TRANSFER_INSTANCE_ID(input, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

	#if RENDER_OBJECT
		o.pos = UnityObjectToClipPos(input.vertex);
		o.screenPos = o.pos;
		o.worldPos = mul(unity_ObjectToWorld, input.vertex);
	#else
		o.vertex = input.vertex;
		o.vertex.xy = (o.vertex.xy - float2(0.5, 0.5)) * float2(2, 2);

		int frustumIndex = input.vertex.x + 2 * (1 - input.vertex.y);
    #if UNITY_SINGLE_PASS_STEREO
      if (unity_StereoEyeIndex == 0)
        o.interpolatedRay = _FrustumCornersWS[frustumIndex];
      else
        o.interpolatedRay = _FrustumCornersWS2[frustumIndex];
    #else
      o.interpolatedRay = _FrustumCornersWS[frustumIndex];
    #endif

	#endif

	return o;
}

struct FragOut
{
	fixed4 col : COLOR0;
	float4 col1 : COLOR1;
	float depth : SV_Depth;
};

fixed4 raymarch(float3 ro, float3 rd, float s, inout float3 raypos, out float objectID);


#ifndef _CAMERA_H_
#define _CAMERA_H_

// thanks MIT Licensed https://github.com/hecomi/uRaymarching for
// camera code here.

inline float3 GetCameraPosition()    { return _WorldSpaceCameraPos;      }
inline float3 GetCameraForward()     { return -UNITY_MATRIX_V[2].xyz;    }
inline float3 GetCameraUp()          { return UNITY_MATRIX_V[1].xyz;     }
inline float3 GetCameraRight()       { return UNITY_MATRIX_V[0].xyz;     }
inline float  GetCameraFocalLength() { return abs(UNITY_MATRIX_P[1][1]); }
inline float  GetCameraNearClip()    { return _ProjectionParams.y;       }
inline float  GetCameraFarClip()     { return _ProjectionParams.z;       }
inline float  GetCameraMaxDistance() { return GetCameraFarClip() - GetCameraNearClip(); }

inline float3 _GetCameraDirection(float2 sp)
{
    float3 camDir      = GetCameraForward();
    float3 camUp       = GetCameraUp();
    float3 camSide     = GetCameraRight();
    float  focalLen    = GetCameraFocalLength();

    return normalize((camSide * sp.x) + (camUp * sp.y) + (camDir * focalLen));
}

inline float3 GetCameraDirection(float4 screenPos)
{
#if UNITY_UV_STARTS_AT_TOP
    screenPos.y *= -1.0;
#endif
    screenPos.x *= _ScreenParams.x / _ScreenParams.y;
    screenPos.xy /= screenPos.w;

    return _GetCameraDirection(screenPos.xy);
}

#endif



#endif
//
// Any code you add here is accessible by Snippets.
//


// Grey scale.
float getGrey(float3 col){ return dot(col, float3(0.299, 0.587, 0.114)); }

// Tri-Planar blending function. Based on an old Nvidia writeup:
// GPU Gems 3 - Ryan Geiss: http://http.developer.nvidia.com/GPUGems3/gpugems3_ch01.html
float3 triplanarTex3D(in float3 p, in float3 normal, sampler2D tex) {
  normal = max(normal*normal, 0.001);
  normal /= (normal.x + normal.y + normal.z );  
	return (tex2Dlod(tex, float4(p.yz, 0, 0)) * normal.x + 
    tex2Dlod(tex, float4(p.zx, 0, 0)) * normal.y + 
    tex2Dlod(tex, float4(p.xy, 0, 0)) * normal.z).xyz;
}

// Texture bump mapping. Four tri-planar lookups, or 12 texture lookups in total.
// Source https://www.shadertoy.com/view/Xs33Df
float3 doBumpMap( in float3 p, in float3 nor, sampler2D tex, float bumpfactor){
  const float eps = 0.001;
  float3 grad = float3( getGrey(triplanarTex3D(float3(p.x-eps, p.y, p.z), nor, tex)),
    getGrey(triplanarTex3D(float3(p.x, p.y-eps, p.z), nor, tex)),
    getGrey(triplanarTex3D(float3(p.x, p.y, p.z-eps), nor, tex)));
  
  grad = (grad - getGrey(triplanarTex3D(p , nor, tex)))/eps; 
          
  grad -= nor*dot(nor, grad);          
                    
  return normalize( nor + grad*bumpfactor );
}

float desertWaves(float3 p, float height)
{
  float disp = min(abs(atan(p.x)), abs(atan(p.z) ))* height;
  disp = 1.0;
  disp *= snoise(p.xz)/5.0;
  return p.y + disp;
}

float metaDesertWaves(float3 p, float height)
{
  float q = desertWaves(p, height);


    const float2 e = float2(1.0,-1.0)*0.5773*0.0005;
    float3 n = normalize( e.xyy*desertWaves( p + e.xyy, height ) + 
					  e.yyx*desertWaves( p+ e.yyx, height ) + 
					  e.yxy*desertWaves( p + e.yxy, height ) + 
					  e.xxx*desertWaves( p+ e.xxx, height ) );

  q = pow(q,1.5 + n.y);

return q;
}

float fersertWaves(float3 p, float height) {
  float disp = 1.0;
  float noise = snoise(p.xz)/5.0;
  
  return p.y + disp;
}

// Light Directional Light
uniform float4 DirectionalLight_2333632768PosAndRange;
uniform float4 DirectionalLight_2333632768ColorAndIntensity;
uniform float3 DirectionalLight_2333632768Direction;
uniform float DirectionalLight_2333632768Penumbra;
uniform int DirectionalLight_2333632768ShadowSteps;
// Light Main Light
uniform float4 MainLight_2474795310PosAndRange;
uniform float4 MainLight_2474795310ColorAndIntensity;
uniform float3 MainLight_2474795310Direction;
uniform float MainLight_2474795310Penumbra;
uniform int MainLight_2474795310ShadowSteps;
// Light Fill Light
uniform float4 FillLight_8033843PosAndRange;
uniform float4 FillLight_8033843ColorAndIntensity;
uniform float3 FillLight_8033843Direction;
uniform float FillLight_8033843Penumbra;
uniform int FillLight_8033843ShadowSteps;

// UNIFORMS AND FUNCTIONS
uniform float3 x_1432955700_86f1660c_offset;
uniform float x_1432955700_86f1660c_angle;
uniform float3 x_1432955700_86f1660c_axis;
float3 modifier_Twist(float3 p , float3 _INP_offset, float _INP_angle, float3 _INP_axis) {
    // Generated from Assets/Raymarching Toolkit/Assets/Snippets/Modifiers/Twist.asset
    p -= _INP_offset.xyz;
    float a = _INP_angle * PI / 180.;
    
    float twistP;
    float2 twistOther;
    if (_INP_axis.x > 0)
    {  twistP = p.x; twistOther = p.yz; }
    else if (_INP_axis.y > 0)
    {  twistP = p.y; twistOther = p.xz; }
    else
    {  twistP = p.z; twistOther = p.xy; }
    
    
    float c = cos(a*twistP);
    float s = sin(a*twistP);
    float2x2  m = float2x2(c,-s,s,c);
    float2 mm = mul(m,twistOther);
    float3 mp = 
      _INP_axis.x * float3(twistP,mm.x,mm.y) +
      _INP_axis.y * float3(mm.x,twistP,mm.y) +
      _INP_axis.z * float3(mm.x,mm.y,twistP);
    
    mp += _INP_offset.xyz;
    return mp;
}
uniform float4x4 _1432955700Matrix;
uniform float4x4 _1432955700InverseMatrix;
uniform float x_1217887453_1d59cc68_freq;
uniform float x_1217887453_1d59cc68_intensity;
uniform float x_1217887453_1d59cc68_speed;
uniform float x_2474795302_1d59cc68_freq;
uniform float x_2474795302_1d59cc68_intensity;
uniform float x_2474795302_1d59cc68_speed;
float3 modifier_Displacement(float3 p , float _INP_freq, float _INP_intensity, float _INP_speed) {
    // Generated from Assets/Raymarching Toolkit/Assets/Snippets/Modifiers/Displacement.asset
    float timeOffset = _Time.z * _INP_speed;
    return p + sin(_INP_freq*p.x + timeOffset)*sin(_INP_freq*p.y + timeOffset)*sin(_INP_freq*p.z + timeOffset)*_INP_intensity;
}
uniform float4x4 _1217887453Matrix;
uniform float4x4 _1217887453InverseMatrix;
uniform float4x4 _2474795302Matrix;
uniform float4x4 _2474795302InverseMatrix;
uniform float x_1217887583_9b42ea9e_MirrorX;
uniform float x_1217887583_9b42ea9e_MirrorY;
uniform float x_1217887583_9b42ea9e_MirrorZ;
uniform float4x4 x_1217887583_9b42ea9e_pivot;
uniform float x_1217887583_9b42ea9e_invert;
uniform float x_1574118176_9b42ea9e_MirrorX;
uniform float x_1574118176_9b42ea9e_MirrorY;
uniform float x_1574118176_9b42ea9e_MirrorZ;
uniform float4x4 x_1574118176_9b42ea9e_pivot;
uniform float x_1574118176_9b42ea9e_invert;
uniform float x_767548858_9b42ea9e_MirrorX;
uniform float x_767548858_9b42ea9e_MirrorY;
uniform float x_767548858_9b42ea9e_MirrorZ;
uniform float4x4 x_767548858_9b42ea9e_pivot;
uniform float x_767548858_9b42ea9e_invert;
float3 modifier_MirrorLocal(float3 p , float _INP_MirrorX, float _INP_MirrorY, float _INP_MirrorZ, float4x4 _INP_pivot, float _INP_invert) {
    // Generated from Assets/Raymarching Toolkit/Examples/Assets/Character Editor/Snippets/MirrorLocal.asset
    float3 MirrorPosition = -objPos(_INP_pivot, float3(0,0,0));
    float3 c1 = lerp(abs(MirrorPosition - p), -abs(p - MirrorPosition), _INP_invert) + MirrorPosition;
    float3 c2 = -abs(p - MirrorPosition) + MirrorPosition;
    return lerp(p, c1, float3(_INP_MirrorX, _INP_MirrorY, _INP_MirrorZ));
    
}
uniform float4x4 _1217887583Matrix;
uniform float4x4 _1217887583InverseMatrix;
uniform float4x4 _1574118176Matrix;
uniform float4x4 _1574118176InverseMatrix;
uniform float4x4 _767548858Matrix;
uniform float4x4 _767548858InverseMatrix;
uniform float x_8033973_6492bb9b_radius;
uniform float x_1574117716_6492bb9b_radius;
uniform float x_2521849469_6492bb9b_radius;
uniform float x_767548794_6492bb9b_radius;
float object_Sphere(float3 p , float _INP_radius) {
    // Generated from Assets/Raymarching Toolkit/Assets/Snippets/Objects/Sphere.asset
    return length(p) - _INP_radius;
}
uniform float x_3946770909_2d2226f4_shape;
uniform float x_3946770909_2d2226f4_radius;
uniform float2 x_3946770909_2d2226f4_boxsize;
uniform float2 x_3946770909_2d2226f4_torussize;
uniform float x_3946770909_2d2226f4_boxthickness;
uniform float x_3899716767_2d2226f4_shape;
uniform float x_3899716767_2d2226f4_radius;
uniform float2 x_3899716767_2d2226f4_boxsize;
uniform float2 x_3899716767_2d2226f4_torussize;
uniform float x_3899716767_2d2226f4_boxthickness;
float object_Multishape(float3 p , float _INP_shape, float _INP_radius, float2 _INP_boxsize, float2 _INP_torussize, float _INP_boxthickness) {
    // Generated from Assets/Raymarching Toolkit/Examples/Assets/Character Editor/Snippets/Multishape.asset
    int s = _INP_shape;
    float r = 0;
    if (s == 0) {
      // sphere
      r = length(p) - _INP_radius;
    } else if (s == 1) {
      // torus
      float2 q = float2(length(p.yz)-_INP_torussize.y,p.x);
     r = length(q)-_INP_torussize.x;
    } else if (s == 2) {
      // box
    float3 d = abs(p)-float3(_INP_boxsize.y,_INP_boxthickness,_INP_boxsize.x);
     r = min(max(d.x, max(d.y,d.z)), 0) + length(max(d, 0));
    }
    return r;
}
uniform float x_1574117786_399aefe0_radius;
uniform float x_1574117786_399aefe0_height;
uniform float x_8033903_399aefe0_radius;
uniform float x_8033903_399aefe0_height;
uniform float x_1217887550_399aefe0_radius;
uniform float x_1217887550_399aefe0_height;
uniform float x_626386650_399aefe0_radius;
uniform float x_626386650_399aefe0_height;
uniform float x_1170833257_399aefe0_radius;
uniform float x_1170833257_399aefe0_height;
uniform float x_8033779_399aefe0_radius;
uniform float x_8033779_399aefe0_height;
uniform float x_3946771200_399aefe0_radius;
uniform float x_3946771200_399aefe0_height;
uniform float x_2999039643_399aefe0_radius;
uniform float x_2999039643_399aefe0_height;
float object_Cylinder(float3 p , float _INP_radius, float _INP_height) {
    // Generated from Assets/Raymarching Toolkit/Assets/Snippets/Objects/Cylinder.asset
    float2 d = abs(float2(length(p.xz),p.y)) - float2(_INP_radius, _INP_height);
    return min(max(d.x,d.y),0.0) + length(max(d,0.0));
    
    // The MIT License
    // Copyright © 2013 Inigo Quilez
    // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}
uniform float3 x_4040879274_b2cbb042_size;
uniform float x_4040879274_b2cbb042_roundedness;
uniform float3 x_3946770872_b2cbb042_size;
uniform float x_3946770872_b2cbb042_roundedness;
uniform float3 x_1217887461_b2cbb042_size;
uniform float x_1217887461_b2cbb042_roundedness;
uniform float3 x_1170833676_b2cbb042_size;
uniform float x_1170833676_b2cbb042_roundedness;
float object_RoundedBox(float3 p , float3 _INP_size, float _INP_roundedness) {
    // Generated from Assets/Raymarching Toolkit/Assets/Snippets/Objects/Rounded Box.asset
        return length(max(abs(p) - _INP_size * 0.5, 0.0)) - _INP_roundedness;
    
    // The MIT License
    // Copyright © 2013 Inigo Quilez
    // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}
uniform float x_908711369_35b6bdec_x;
uniform float x_908711369_35b6bdec_y;
uniform float x_908711369_35b6bdec_z;
float object_Ellipsoid(float3 p , float _INP_x, float _INP_y, float _INP_z) {
    // Generated from Assets/Raymarching Toolkit/Assets/Snippets/Objects/Ellipsoid.asset
    return sdEllipsoid(p, float3(_INP_x, _INP_y, _INP_z));
    
    // The MIT License
    // Copyright © 2013 Inigo Quilez
    // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}
// uniforms for Eye Socket Subtraction
uniform float4x4 _8033973Matrix;
uniform float _8033973MinScale;
// uniforms for RM_Head
uniform float4x4 _3946770909Matrix;
uniform float _3946770909MinScale;
// uniforms for Accessory Shape
uniform float4x4 _3899716767Matrix;
uniform float _3899716767MinScale;
// uniforms for Eye Socket
uniform float4x4 _1574117716Matrix;
uniform float _1574117716MinScale;
// uniforms for L Upperarm
uniform float4x4 _1574117786Matrix;
uniform float _1574117786MinScale;
// uniforms for L Lowerarm
uniform float4x4 _8033903Matrix;
uniform float _8033903MinScale;
// uniforms for L Hand
uniform float4x4 _4040879274Matrix;
uniform float _4040879274MinScale;
// uniforms for R Upperarm
uniform float4x4 _1217887550Matrix;
uniform float _1217887550MinScale;
// uniforms for R Lowerarm
uniform float4x4 _626386650Matrix;
uniform float _626386650MinScale;
// uniforms for R Hand
uniform float4x4 _3946770872Matrix;
uniform float _3946770872MinScale;
// uniforms for L Thigh
uniform float4x4 _1170833257Matrix;
uniform float _1170833257MinScale;
// uniforms for L Calf
uniform float4x4 _8033779Matrix;
uniform float _8033779MinScale;
// uniforms for L Foot
uniform float4x4 _1217887461Matrix;
uniform float _1217887461MinScale;
// uniforms for R Thigh
uniform float4x4 _3946771200Matrix;
uniform float _3946771200MinScale;
// uniforms for R Calf
uniform float4x4 _2999039643Matrix;
uniform float _2999039643MinScale;
// uniforms for R Foot
uniform float4x4 _1170833676Matrix;
uniform float _1170833676MinScale;
// uniforms for Body
uniform float4x4 _908711369Matrix;
uniform float _908711369MinScale;
// uniforms for Butt
uniform float4x4 _2521849469Matrix;
uniform float _2521849469MinScale;
// uniforms for Eye L
uniform float4x4 _767548794Matrix;
uniform float _767548794MinScale;
uniform float x_3758554532_44192f17_intensity;
uniform float x_1217887424_44192f17_intensity;
uniform float x_3496432050_44192f17_intensity;
uniform float x_4161839055_44192f17_intensity;
uniform float x_1217887387_44192f17_intensity;
uniform float x_1574117848_44192f17_intensity;
uniform float x_1170833352_44192f17_intensity;
float2 blend_Smooth(float2 a, float2 b , float _INP_intensity) {
    // Generated from Assets/Raymarching Toolkit/Assets/Snippets/Blends/Smooth.asset
    float h = saturate(0.5 + 0.5*(b - a) / _INP_intensity);
    return lerp(b, a, h) - _INP_intensity*h*(1 - h);
}
uniform float4 x_8033973_da843a44_color;
uniform float4 x_3946770909_da843a44_color;
uniform float4 x_3899716767_da843a44_color;
uniform float4 x_1574117716_da843a44_color;
uniform float4 x_1574117786_da843a44_color;
uniform float4 x_8033903_da843a44_color;
uniform float4 x_4040879274_da843a44_color;
uniform float4 x_1217887550_da843a44_color;
uniform float4 x_626386650_da843a44_color;
uniform float4 x_3946770872_da843a44_color;
uniform float4 x_1170833257_da843a44_color;
uniform float4 x_8033779_da843a44_color;
uniform float4 x_1217887461_da843a44_color;
uniform float4 x_3946771200_da843a44_color;
uniform float4 x_2999039643_da843a44_color;
uniform float4 x_1170833676_da843a44_color;
uniform float4 x_908711369_da843a44_color;
uniform float4 x_2521849469_da843a44_color;
uniform float4 x_767548794_da843a44_color;
float3 material_SimpleColor(inout float3 normal, float3 p, float3 rayDir, float4 _INP_color) {
    // Generated from Assets/Raymarching Toolkit/Assets/Snippets/Materials/SimpleColor.asset
    return _INP_color;
}
float3 MaterialFunc(float nf, inout float3 normal, float3 p, float3 rayDir, out float objectID)
{
    objectID = ceil(nf) / (float)19;
    [branch] if (nf <= 1) {
    //    objectID = 0.05263158;
        return material_SimpleColor(normal, objPos(_8033973Matrix, p), rayDir, x_8033973_da843a44_color);
    }
    else if(nf <= 2) {
    //    objectID = 0.1052632;
        return material_SimpleColor(normal, objPos(_3946770909Matrix, p), rayDir, x_3946770909_da843a44_color);
    }
    else if(nf <= 3) {
    //    objectID = 0.1578947;
        return material_SimpleColor(normal, objPos(_3899716767Matrix, p), rayDir, x_3899716767_da843a44_color);
    }
    else if(nf <= 4) {
    //    objectID = 0.2105263;
        return material_SimpleColor(normal, objPos(_1574117716Matrix, p), rayDir, x_1574117716_da843a44_color);
    }
    else if(nf <= 5) {
    //    objectID = 0.2631579;
        return material_SimpleColor(normal, objPos(_1574117786Matrix, p), rayDir, x_1574117786_da843a44_color);
    }
    else if(nf <= 6) {
    //    objectID = 0.3157895;
        return material_SimpleColor(normal, objPos(_8033903Matrix, p), rayDir, x_8033903_da843a44_color);
    }
    else if(nf <= 7) {
    //    objectID = 0.368421;
        return material_SimpleColor(normal, objPos(_4040879274Matrix, p), rayDir, x_4040879274_da843a44_color);
    }
    else if(nf <= 8) {
    //    objectID = 0.4210526;
        return material_SimpleColor(normal, objPos(_1217887550Matrix, p), rayDir, x_1217887550_da843a44_color);
    }
    else if(nf <= 9) {
    //    objectID = 0.4736842;
        return material_SimpleColor(normal, objPos(_626386650Matrix, p), rayDir, x_626386650_da843a44_color);
    }
    else if(nf <= 10) {
    //    objectID = 0.5263158;
        return material_SimpleColor(normal, objPos(_3946770872Matrix, p), rayDir, x_3946770872_da843a44_color);
    }
    else if(nf <= 11) {
    //    objectID = 0.5789474;
        return material_SimpleColor(normal, objPos(_1170833257Matrix, p), rayDir, x_1170833257_da843a44_color);
    }
    else if(nf <= 12) {
    //    objectID = 0.6315789;
        return material_SimpleColor(normal, objPos(_8033779Matrix, p), rayDir, x_8033779_da843a44_color);
    }
    else if(nf <= 13) {
    //    objectID = 0.6842105;
        return material_SimpleColor(normal, objPos(_1217887461Matrix, p), rayDir, x_1217887461_da843a44_color);
    }
    else if(nf <= 14) {
    //    objectID = 0.7368421;
        return material_SimpleColor(normal, objPos(_3946771200Matrix, p), rayDir, x_3946771200_da843a44_color);
    }
    else if(nf <= 15) {
    //    objectID = 0.7894737;
        return material_SimpleColor(normal, objPos(_2999039643Matrix, p), rayDir, x_2999039643_da843a44_color);
    }
    else if(nf <= 16) {
    //    objectID = 0.8421053;
        return material_SimpleColor(normal, objPos(_1170833676Matrix, p), rayDir, x_1170833676_da843a44_color);
    }
    else if(nf <= 17) {
    //    objectID = 0.8947368;
        return material_SimpleColor(normal, objPos(_908711369Matrix, p), rayDir, x_908711369_da843a44_color);
    }
    else if(nf <= 18) {
    //    objectID = 0.9473684;
        return material_SimpleColor(normal, objPos(_2521849469Matrix, p), rayDir, x_2521849469_da843a44_color);
    }
    else if(nf <= 19) {
    //    objectID = 1;
        return material_SimpleColor(normal, objPos(_767548794Matrix, p), rayDir, x_767548794_da843a44_color);
    }
        objectID = 0;
        return float3(1.0, 0.0, 1.0);
    }

#define raymarch defaultRaymarch

float2 map(float3 p) {
	float2 result = float2(1.0, 0.0);
	
{
    float3 p_1432955700 = objPos(_1432955700InverseMatrix, modifier_Twist(objPos(_1432955700Matrix, p), x_1432955700_86f1660c_offset, x_1432955700_86f1660c_angle, x_1432955700_86f1660c_axis));
    float3 p_1217887453 = objPos(_1217887453InverseMatrix, modifier_Displacement(objPos(_1217887453Matrix, p_1432955700), x_1217887453_1d59cc68_freq, x_1217887453_1d59cc68_intensity, x_1217887453_1d59cc68_speed));
    float3 p_1217887583 = objPos(_1217887583InverseMatrix, modifier_MirrorLocal(objPos(_1217887583Matrix, p_1217887453), x_1217887583_9b42ea9e_MirrorX, x_1217887583_9b42ea9e_MirrorY, x_1217887583_9b42ea9e_MirrorZ, x_1217887583_9b42ea9e_pivot, x_1217887583_9b42ea9e_invert));
    float _8033973Distance = object_Sphere(objPos(_8033973Matrix, p_1217887583), x_8033973_6492bb9b_radius) * _8033973MinScale;
    float _3946770909Distance = object_Multishape(objPos(_3946770909Matrix, p_1217887583), x_3946770909_2d2226f4_shape, x_3946770909_2d2226f4_radius, x_3946770909_2d2226f4_boxsize, x_3946770909_2d2226f4_torussize, x_3946770909_2d2226f4_boxthickness) * _3946770909MinScale;
    float _3899716767Distance = object_Multishape(objPos(_3899716767Matrix, p_1217887583), x_3899716767_2d2226f4_shape, x_3899716767_2d2226f4_radius, x_3899716767_2d2226f4_boxsize, x_3899716767_2d2226f4_torussize, x_3899716767_2d2226f4_boxthickness) * _3899716767MinScale;
    float _1574117716Distance = object_Sphere(objPos(_1574117716Matrix, p_1217887583), x_1574117716_6492bb9b_radius) * _1574117716MinScale;
    float _1574117786Distance = object_Cylinder(objPos(_1574117786Matrix, p_1217887453), x_1574117786_399aefe0_radius, x_1574117786_399aefe0_height) * _1574117786MinScale;
    float _8033903Distance = object_Cylinder(objPos(_8033903Matrix, p_1217887453), x_8033903_399aefe0_radius, x_8033903_399aefe0_height) * _8033903MinScale;
    float _4040879274Distance = object_RoundedBox(objPos(_4040879274Matrix, p_1217887453), x_4040879274_b2cbb042_size, x_4040879274_b2cbb042_roundedness) * _4040879274MinScale;
    float _1217887550Distance = object_Cylinder(objPos(_1217887550Matrix, p_1217887453), x_1217887550_399aefe0_radius, x_1217887550_399aefe0_height) * _1217887550MinScale;
    float _626386650Distance = object_Cylinder(objPos(_626386650Matrix, p_1217887453), x_626386650_399aefe0_radius, x_626386650_399aefe0_height) * _626386650MinScale;
    float _3946770872Distance = object_RoundedBox(objPos(_3946770872Matrix, p_1217887453), x_3946770872_b2cbb042_size, x_3946770872_b2cbb042_roundedness) * _3946770872MinScale;
    float _1170833257Distance = object_Cylinder(objPos(_1170833257Matrix, p_1217887453), x_1170833257_399aefe0_radius, x_1170833257_399aefe0_height) * _1170833257MinScale;
    float _8033779Distance = object_Cylinder(objPos(_8033779Matrix, p_1217887453), x_8033779_399aefe0_radius, x_8033779_399aefe0_height) * _8033779MinScale;
    float _1217887461Distance = object_RoundedBox(objPos(_1217887461Matrix, p_1217887453), x_1217887461_b2cbb042_size, x_1217887461_b2cbb042_roundedness) * _1217887461MinScale;
    float _3946771200Distance = object_Cylinder(objPos(_3946771200Matrix, p_1217887453), x_3946771200_399aefe0_radius, x_3946771200_399aefe0_height) * _3946771200MinScale;
    float _2999039643Distance = object_Cylinder(objPos(_2999039643Matrix, p_1217887453), x_2999039643_399aefe0_radius, x_2999039643_399aefe0_height) * _2999039643MinScale;
    float _1170833676Distance = object_RoundedBox(objPos(_1170833676Matrix, p_1217887453), x_1170833676_b2cbb042_size, x_1170833676_b2cbb042_roundedness) * _1170833676MinScale;
    float3 p_2474795302 = objPos(_2474795302InverseMatrix, modifier_Displacement(objPos(_2474795302Matrix, p_1217887453), x_2474795302_1d59cc68_freq, x_2474795302_1d59cc68_intensity, x_2474795302_1d59cc68_speed));
    float _908711369Distance = object_Ellipsoid(objPos(_908711369Matrix, p_2474795302), x_908711369_35b6bdec_x, x_908711369_35b6bdec_y, x_908711369_35b6bdec_z) * _908711369MinScale;
    float3 p_1574118176 = objPos(_1574118176InverseMatrix, modifier_MirrorLocal(objPos(_1574118176Matrix, p_1217887453), x_1574118176_9b42ea9e_MirrorX, x_1574118176_9b42ea9e_MirrorY, x_1574118176_9b42ea9e_MirrorZ, x_1574118176_9b42ea9e_pivot, x_1574118176_9b42ea9e_invert));
    float _2521849469Distance = object_Sphere(objPos(_2521849469Matrix, p_1574118176), x_2521849469_6492bb9b_radius) * _2521849469MinScale;
    float3 p_767548858 = objPos(_767548858InverseMatrix, modifier_MirrorLocal(objPos(_767548858Matrix, p_1217887453), x_767548858_9b42ea9e_MirrorX, x_767548858_9b42ea9e_MirrorY, x_767548858_9b42ea9e_MirrorZ, x_767548858_9b42ea9e_pivot, x_767548858_9b42ea9e_invert));
    float _767548794Distance = object_Sphere(objPos(_767548794Matrix, p_767548858), x_767548794_6492bb9b_radius) * _767548794MinScale;
    result = opU(blend_Smooth(blend_Smooth(blend_Smooth(blend_Smooth(blend_Smooth(opSubtract(float2(_8033973Distance, /*material ID*/0.5), blend_Smooth(blend_Smooth(float2(_3946770909Distance, /*material ID*/1.5), float2(_3899716767Distance, /*material ID*/2.5), x_1217887424_44192f17_intensity), float2(_1574117716Distance, /*material ID*/3.5), x_1217887424_44192f17_intensity)), blend_Smooth(blend_Smooth(float2(_1574117786Distance, /*material ID*/4.5), float2(_8033903Distance, /*material ID*/5.5), x_3496432050_44192f17_intensity), float2(_4040879274Distance, /*material ID*/6.5), x_3496432050_44192f17_intensity), x_3758554532_44192f17_intensity), blend_Smooth(blend_Smooth(float2(_1217887550Distance, /*material ID*/7.5), float2(_626386650Distance, /*material ID*/8.5), x_4161839055_44192f17_intensity), float2(_3946770872Distance, /*material ID*/9.5), x_4161839055_44192f17_intensity), x_3758554532_44192f17_intensity), blend_Smooth(blend_Smooth(float2(_1170833257Distance, /*material ID*/10.5), float2(_8033779Distance, /*material ID*/11.5), x_1217887387_44192f17_intensity), float2(_1217887461Distance, /*material ID*/12.5), x_1217887387_44192f17_intensity), x_3758554532_44192f17_intensity), blend_Smooth(blend_Smooth(float2(_3946771200Distance, /*material ID*/13.5), float2(_2999039643Distance, /*material ID*/14.5), x_1574117848_44192f17_intensity), float2(_1170833676Distance, /*material ID*/15.5), x_1574117848_44192f17_intensity), x_3758554532_44192f17_intensity), blend_Smooth(float2(_908711369Distance, /*material ID*/16.5), float2(_2521849469Distance, /*material ID*/17.5), x_1170833352_44192f17_intensity), x_3758554532_44192f17_intensity), float2(_767548794Distance, /*material ID*/18.5));
    }
	return result;
}

float3 getLights(in float3 color, in float3 pos, in float3 normal) {
	LightInput input;
	input.pos = pos;
	input.color = color;
	input.normal = normal;

	float3 lightValue = float3(0, 0, 0);
	
{
LightInfo light;
light.posAndRange = DirectionalLight_2333632768PosAndRange;
light.colorAndIntensity = DirectionalLight_2333632768ColorAndIntensity;
light.direction = DirectionalLight_2333632768Direction;
lightValue += getDirectionalLight(input, light)* softshadow(input.pos, -light.direction, INFINITY, DirectionalLight_2333632768Penumbra, DirectionalLight_2333632768ShadowSteps);
}
{
LightInfo light;
light.posAndRange = MainLight_2474795310PosAndRange;
light.colorAndIntensity = MainLight_2474795310ColorAndIntensity;
light.direction = MainLight_2474795310Direction;
lightValue += getDirectionalLight(input, light)* softshadow(input.pos, -light.direction, INFINITY, MainLight_2474795310Penumbra, MainLight_2474795310ShadowSteps);
}
{
LightInfo light;
light.posAndRange = FillLight_8033843PosAndRange;
light.colorAndIntensity = FillLight_8033843ColorAndIntensity;
light.direction = FillLight_8033843Direction;
lightValue += getDirectionalLight(input, light);
}
	return lightValue;
}

fixed4 defaultRaymarch(float3 ro, float3 rd, float s, inout float3 raypos, out float objectID)
{
	bool found = false;
	objectID = 0.0;

	float2 d;
	float t = 0; // current distance traveled along ray
	float3 p = float3(0, 0, 0);

#if FADE_TO_SKYBOX
	const float skyboxAlpha = 0;
#else
	const float skyboxAlpha = 1;
#endif

#if FOG_ENABLED
	fixed4 ret = fixed4(FogColor, skyboxAlpha);
#else
	fixed4 ret = fixed4(0,0,0,0);
#endif

	int numSteps;
	d = trace(ro, rd, raypos, numSteps, found);
	t = d.x;
	p = raypos;

#if DEBUG_STEPS
	float3 c = float3(1,0,0) * (1-(t / (float)numSteps));
	return fixed4(c, 1);
#elif DEBUG_MATERIALS
	float3 c = float3(1,1,1) * (d.y / 20);
	return fixed4(c, 1);
#endif

	[branch]
	if (found)
	{
		// First, we sample the map() function around our hit point to find the normal.
		float3 n = calcNormal(p);

		// Then, we get the color of the world at that point, based on our material ids.
		float3 color = MaterialFunc(d.y, n, p, rd, objectID);
		float3 light = getLights(color, p, n);

		// The ambient color is applied.
		color *= _AmbientColor.xyz;

		// And lights are added.
		color += light;

		// If enabled, darken with ambient occlusion.
		#if AO_ENABLED
		color *= ambientOcclusion(p, n);
		#endif

		// If fog is enabled, lerp towards the fog color based on the distance.
		#if FOG_ENABLED
		color = lerp(color, FogColor, 1.0-exp2(-FogDensity * t * t));
		#endif

		// If fading to the skybox is enabled, reduce the alpha value of the output pizel.
		#if FADE_TO_SKYBOX
		float alpha = lerp(1.0, 0, 1.0 - (_DrawDistance - t) / FadeToSkyboxDistance);
		#else
		float alpha = 1.0;
		#endif

		ret = fixed4(color, alpha);
	}

	raypos = p;
	return ret;
}


FragOut frag (v2f i)
{
    UNITY_SETUP_INSTANCE_ID(i);

    #if RENDER_OBJECT
    float3 rayDir = GetCameraDirection(i.screenPos);
    #else
    float3 rayDir = normalize(i.interpolatedRay);
    #endif

  	float3 rayOrigin = _WorldSpaceCameraPos + _ProjectionParams.y * rayDir;
    
	float3 raypos = float3(0, 0, 0);
	float objectID = 0.0;
	
	FragOut o;
	o.col = raymarch(rayOrigin, rayDir, _DrawDistance, raypos, objectID);
	o.col1 = float4(objectID, 0, 0, 1);
  #if !SKIP_DEPTH_WRITE
	o.depth = compute_depth(mul(UNITY_MATRIX_VP, float4(raypos, 1.0)));
	
	#if !FOG_ENABLED
	clip(o.col.a < 0.001 ? -1.0 : 1.0);
	#endif
  #endif
	
	return o;
}

ENDCG

}
}
}
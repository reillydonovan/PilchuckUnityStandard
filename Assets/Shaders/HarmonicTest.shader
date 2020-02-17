Shader "HarmonicTest"
{
	/*
#define PI 3.14159265
#define TWOPI 6.28318531

#ifdef GL_ES
precision highp float;
#endif

varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vGlobalNormal;
varying vec3 vPosition;
varying vec4 vGlobalPosition;

uniform float shape1A;
uniform float shape1B;
uniform float shape1M;
uniform float shape1N1;
uniform float shape1N2;
uniform float shape1N3;

uniform float shape2A;
uniform float shape2B;
uniform float shape2M;
uniform float shape2N1;
uniform float shape2N2;
uniform float shape2N3;

float radiusForAngle(float angle, float a, float b, float m, float n1, float n2, float n3) {
  float tempA = abs(cos(angle * m * 0.25) / a);
  float tempB = abs(sin(angle * m * 0.25) / b);
  float tempAB = pow(tempA, n2) + pow(tempB, n3);
  return abs(pow(tempAB, - 1.0 / n1));
}

vec3 superPositionForPosition(vec3 p) {
  float r = length(p);

  float phi = atan(p.y, p.x);
  float theta = r == 0.0 ? 0.0 : asin(p.z / r);

  float superRadiusPhi = radiusForAngle(phi, shape1A, shape1B, shape1M, shape1N1, shape1N2, shape1N3);
  float superRadiusTheta = radiusForAngle(theta, shape2A, shape2B, shape2M, shape2N1, shape2N2, shape2N3);

  p.x = r * superRadiusPhi * cos(phi) * superRadiusTheta * cos(theta);
  p.y = r * superRadiusPhi * sin(phi) * superRadiusTheta * cos(theta);
  p.z = r * superRadiusTheta * sin(theta);

  return p;
}

void main() {
  vUv = uv;

  vNormal = normal;
  vGlobalNormal = normalize(normalMatrix * normal);

  vPosition = superPositionForPosition(position);
  vGlobalPosition = projectionMatrix * modelViewMatrix * vec4(vPosition, 1.0);

  gl_Position = vGlobalPosition;
}
		Fallback "Diffuse"
			CustomEditor "ASEMaterialInspector"
			*/
}
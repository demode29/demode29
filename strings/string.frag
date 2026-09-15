#version 300 es
precision highp float;

in float vU;
in float vN;
in float vEnergy;
uniform vec3 uColor;
uniform float uAmp;
out vec4 outColor;

void main() {
  float edge = 1.0 - smoothstep(0.45, 1.0, abs(vN));
  float glow = 0.38 + 0.62 * clamp(uAmp * 3.2 + vEnergy * 2.4, 0.0, 1.0);
  vec3 col = uColor * (0.52 + 0.48 * edge) * glow;
  float fade = smoothstep(0.0, 0.035, vU) * smoothstep(1.0, 0.965, vU);
  outColor = vec4(col * fade, 1.0);
}

#version 300 es

// string.vert — this is the file to tweak.
// Save, then refresh the page (shaders load with cache disabled).
//
// u = 0..1 along the string
// p = where you clicked (neck ~0.25, bridge ~0.8)
// t = seconds since the pluck

const int   HARMONICS = 12;      // more = more snarl, more GPU
const float STIFFNESS = 0.00038; // wound-string inharmonicity
const float DAMP      = 0.52;    // higher dies faster; high modes die first
const float GAIN      = 1.85;    // overall wave height
const float POLAR     = 1.004;   // second-axis detune (shimmer)
const float POLAR_MIX = 0.32;    // how much of that axis you see

layout(location=0) in vec3 aPos;
layout(location=1) in float aU;
layout(location=2) in float aSide;
uniform mat4 uMVP;
uniform float uAmp, uPluck, uTime, uOmega, uWidth, uY;
out float vU;
out float vN;
out float vEnergy;

float modal(float u, float t, float p, float omega, float B, float damp) {
  p = clamp(p, 0.08, 0.92);
  float y = 0.0;
  const float pi = 3.14159265;
  for (int n = 1; n <= HARMONICS; n++) {
    float fn = float(n);
    float a = sin(fn * pi * p) / (fn * fn);
    float stiff = sqrt(1.0 + B * fn * fn);
    float decay = exp(-damp * fn * t);
    y += a * sin(fn * pi * u) * cos(omega * fn * stiff * t) * decay;
  }
  return y * GAIN;
}

void main() {
  float zWave = modal(aU, uTime, uPluck, uOmega, STIFFNESS, DAMP);
  float yWave = modal(aU, uTime, uPluck, uOmega * POLAR, STIFFNESS * 0.82, DAMP * 1.35);
  vec3 pos = aPos;
  pos.y = uY + aSide * uWidth + uAmp * yWave * POLAR_MIX;
  pos.z += uAmp * zWave;
  vU = aU;
  vN = aSide;
  vEnergy = abs(zWave) * uAmp;
  gl_Position = uMVP * vec4(pos, 1.0);
}

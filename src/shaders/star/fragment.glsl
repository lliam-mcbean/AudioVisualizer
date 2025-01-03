uniform float uTime;
uniform float uSpeedFactor;

varying vec2 vUv;

void main() {
  float pulse = (sin(uTime * 4.0) + 1.0) * 0.015;
  float strength = 0.05 / (distance(vec2(vUv.x, (vUv.y - 0.5) * 20.0 + 0.5), vec2(0.5)));
  strength *= (0.05 + pulse) / (distance(vec2(vUv.y, (vUv.x - 0.5) * 20.0 + 0.5), vec2(0.5)));

  vec3 color = vec3(0.0, 0.686, 0.918); 
  vec3 finalColor = color * strength * 10.0; // Amplify for bloom

  // The alpha channel can help control blending intensity for bloom effect
  gl_FragColor = vec4(finalColor, clamp(strength, 0.0, 1.0) - 0.2);
}
uniform float uTime;

varying vec2 vUv;

void main() {
  float pulse = (sin(uTime * 4.0) + 1.0) * 0.015;
  float strength = 20.0 / (distance(vec2(vUv.x, (vUv.y - 0.5) * 100.0 + 0.5), vec2(0.5)));
  strength *= (20.0 + pulse) / (distance(vec2(vUv.y, (vUv.x) * 100.0 + 0.5), vec2(0.5)));

  vec3 color = vec3(0.0, 0.686, 0.918); 
  vec3 finalColor = color * strength;

  gl_FragColor = vec4(finalColor, strength - 0.1);
}

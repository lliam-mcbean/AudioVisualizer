// Fragment Shader
varying vec3 vNormal;
varying vec3 vPosition;

void main() {
  // Calculate the view direction
  vec3  color = vec3(123.0 / 255.0, 204.0 / 255.0, 235.0 / 255.0);
  gl_FragColor = vec4(color, 0.2);
}

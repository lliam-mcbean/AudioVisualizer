// Fragment Shader
varying vec3 vNormal;
varying vec3 vPosition;

void main() {
  // Calculate the view direction
  vec3 viewDir = normalize(cameraPosition - vPosition);

  // Calculate the edge intensity based on the angle between the normal and view direction
  float edgeIntensity = 1.0 - abs(dot(viewDir, vNormal));

  // Threshold the intensity to emphasize edges
  edgeIntensity = smoothstep(0.1, 0.3, edgeIntensity);

  // Set the color based on the edge intensity
  vec3 edgeColor = vec3(edgeIntensity);
  gl_FragColor = vec4(edgeColor, 1.0);
}

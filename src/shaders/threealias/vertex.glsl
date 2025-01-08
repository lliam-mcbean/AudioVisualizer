// Vertex Shader
varying vec3 vNormal;
varying vec3 vPosition;

void main() {
  vNormal = normalize(normalMatrix * normal); // Transform normal to world space
  vPosition = (modelMatrix * vec4(position, 1.0)).xyz; // Transform position to world space
  gl_Position = projectionMatrix * viewMatrix * vec4(vPosition, 1.0); // Standard transformation
}
    uniform sampler2D uTexture;
    
    varying vec2 vUv;

    void main() {
      vUv = uv;
      float heightScale = 20.0;

      vec4 textureColor = texture2D(uTexture, vUv);

      float height = textureColor.r * 2.0 + textureColor.g * 0.4 + textureColor.b * 0.1; 
      vec3 displacedPosition = position + normal * height * heightScale;

      gl_Position = projectionMatrix * modelViewMatrix * vec4(displacedPosition, 1.0);
    }
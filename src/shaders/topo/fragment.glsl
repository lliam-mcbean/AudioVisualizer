    varying vec2 vUv;
    uniform sampler2D uTexture;

    void main() {
      // Simply render the texture in the fragment shader
      vec4 color = texture2D(uTexture, vUv);
      gl_FragColor = color;
    }
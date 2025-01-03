varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;

uniform float uVolume;


void main() {
    vUv = uv;
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    vec4 modelNormal = modelMatrix * vec4(normal, 0.0);

    float maxVolume = clamp(uVolume / 2.0, 0.0, 1.2);

    float magnitude = sqrt(pow(position.x, 2.0) + pow(position.y, 2.0) + pow(position.z, 2.0));
    magnitude /= maxVolume;
    vec3 normalized = (position / magnitude) * 10.0;
    vec3 finalPosition = mix(position * 10.0, normalized, maxVolume);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(finalPosition, 1.0);

    vPosition = modelPosition.xyz;
    vNormal = modelNormal.xyz;
}
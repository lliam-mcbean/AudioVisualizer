uniform vec2 uResolution;
uniform float uSize;
uniform float uTime;

// Hash function for pseudo-random generation
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

// Random 2D function
vec2 random2D(vec2 st) {
    return vec2(hash(dot(st, vec2(127.1, 311.7))), 
                hash(dot(st, vec2(269.5, 183.3))));
}

void main()
{
    // Final position
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    // Add random motion based on particle position and time
    vec2 randomOffset = random2D(modelPosition.xy + (uTime * 0.00001)) * 2.0 - 1.0; // Range [-1, 1]
    randomOffset *= 0.05; // Scale randomness

    // Apply the random offset to the position
    modelPosition.x += hash(uTime);

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;

    gl_Position = projectedPosition;

    // Point size
    gl_PointSize = uSize * uResolution.y;
    gl_PointSize *= (1.0 / -viewPosition.z);
}
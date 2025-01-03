varying vec3 vPosition;
varying vec3 vNormal;

uniform float uTime;
uniform float uVolume;

float random2D(vec2 value)
{
    return fract(sin(dot(value.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(){
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    // glitch
    float glitchTime = uTime - modelPosition.y;
    float glitchStrength = sin(glitchTime) + sin(glitchTime * 3.45) + sin(glitchTime * 8.45);
    glitchStrength /= 3.0;
    glitchStrength = smoothstep(0.03, 0.04, glitchStrength);
    glitchStrength *= 0.25;
    modelPosition.x += (random2D(modelPosition.xz + uTime) - 0.5) * glitchStrength;
    modelPosition.z += (random2D(modelPosition.zx + uTime) - 0.5) * glitchStrength;

    gl_Position = projectionMatrix * viewMatrix * modelPosition;

    // model normal
    vec4 modelNormal = modelMatrix * vec4(normal, 0.0);

    // varyings
    vPosition = modelPosition.xyz;
    vNormal = modelNormal.xyz;
}
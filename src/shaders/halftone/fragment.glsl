uniform vec2 uResolution;

varying vec3 vNormal;
varying vec3 vPosition;

vec3 halftone(
    vec3 color, 
    float repetetions, 
    vec3 direction, 
    float low,
    float high,
    vec3 pointColor,
    vec3 normal
) {
    float intensity = dot(normal, direction);
    intensity = smoothstep(low, high, intensity);

    vec2 uv = gl_FragCoord.xy / uResolution.y;
    uv *= repetetions;
    uv = mod(uv, 1.0);

    float point = distance(uv, vec2(0.5));
    point = 1.0 - step(0.5 * intensity, point);

    return mix(color, pointColor, point);
}

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = vec3(188.0 / 255.0, 128.0 / 255.0, 154.0 / 255.0);

    // lights
    vec3 light = vec3(0.0);

    light += ambientLight(
        vec3(1.0),
        1.0
    );

    light += directionalLight(
        vec3(1.0, 1.0, 1.0),
        1.0, 
        normal, 
        vec3(1.0, 1.0, 1.0),
        viewDirection,
        1.0
    );

    color *= light;

    // halftone
    color = halftone(
        color, 
        200.0,
        vec3(0.0, -1.0, 0.0),
        -0.8, 
        1.5,
        vec3( 255.0 / 242.0, 255.0 / 112.0, 255.0 / 112.0), 
        normal
    );

    color = halftone(
        color, 
        200.0,
        vec3(0.0, 1.0, 0.0),
        -0.8, 
        1.5,
        vec3( 255.0 / 242.0, 255.0 / 112.0, 255.0 / 112.0), 
        normal
    );

    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
}
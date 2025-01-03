<template lang="">
    <div>
        
    </div>
</template>
<script setup>
    import {inject, onMounted, defineProps} from 'vue'
    import * as THREE from 'three'
    import fragmentShader from '../../../shaders/antialias/fragment.glsl'
    import vertexShader from '../../../shaders/antialias/vertex.glsl'

    const scene = inject('scene')

    const props = defineProps({
        volume: Number
    })
    

    onMounted(() => {
        let meshes = []
        const geometry = new THREE.BoxGeometry(1,10,1)
        const material = new THREE.ShaderMaterial({
            fragmentShader,
            vertexShader,
            uniforms: {
                thickness: {value: 2}
            }
        })

        for (let j = -15; j < 15; j++) {
            for (let i = 0; i < 30; i++) {
                const mesh = new THREE.Mesh(geometry, material)
                mesh.position.set(i - 15, -10, j)
                scene.add(mesh)
                meshes.push(mesh)
            }
        }

        let clock = new THREE.Clock()

        function mapRange(value, oldMin, oldMax, newMin, newMax) {
            return newMin + ((value - oldMin) / (oldMax - oldMin)) * (newMax - newMin);
        }

        const lerp = (start, end, t) => {
            return start + (end - start) * t;
        };

        const animate = () => {
    const time = clock.getElapsedTime();

    meshes.forEach((mesh) => {
        // Calculate distance from the center
        let distance = mesh.position.distanceTo({ x: 0, y: 0, z: 0 });

        // Map the distance to create an offset based on volume
        let offset = mapRange(distance, 0, 30, 5, -5);
        let mappedDistance = mapRange(distance, 0, 30, 1, 0)
        let mappedVolume = mapRange(props.volume, 0, 50, 0, 2)

        // Calculate the ripple effect based on the volume and distance
        let rippleRadius = props.volume; // Adjust propagation speed
            // Slow down the ripple by dividing the time and/or offset by a factor
            let angle = (rippleRadius - distance) * 0.1 + time * 0.5 + offset ;
            mesh.scale.set(1, (lerp(mesh.scale.y, Math.sin(angle), 0.08) - (mappedDistance * 0.5) * mappedVolume), 1); // Create the ripple effect

    });

    requestAnimationFrame(animate);
};
       animate()
    })
</script>
<style lang="">
    
</style>
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

        for (let i = 0; i < 30; i++) {
            const mesh = new THREE.Mesh(geometry, material)
            mesh.position.set(i * 2 - 30, 0, 0)
            scene.add(mesh)
            meshes.push(mesh)
        }

        let clock = new THREE.Clock()

        function mapRange(value, oldMin, oldMax, newMin, newMax) {
            return newMin + ((value - oldMin) / (oldMax - oldMin)) * (newMax - newMin);
        }

        const lerp = (start, end, t) => {
            return start + (end - start) * t;
        };

        const animate = () => {
            const time = clock.getElapsedTime()

            meshes.forEach((mesh) => {
                const distance = Math.abs(mesh.position.x);

                const proximityFactor = mapRange(distance, 0, 30, 1, 0);

                const offset = mapRange(distance, 0, 30, 1, -1);
                const angle = (time * 5) + offset;

                const scaleY = (Math.sin(angle) * (props.volume * proximityFactor))  * 0.1;

                mesh.scale.set(1, lerp(mesh.scale.y, 0.1 + Math.max(0, scaleY), 0.08), 1);
            });
              

            requestAnimationFrame(animate)
        }

        animate()
    })
</script>
<style lang="">
    
</style>
<template lang="">
    <div>
        
    </div>
</template>
<script setup>
    import {inject, onMounted, defineProps, watch} from 'vue'
    import * as THREE from 'three'
    import fragmentShader from '../../../shaders/antialias/fragment.glsl'
    import vertexShader from '../../../shaders/antialias/vertex.glsl'

    const scene = inject('scene')
    const camera = inject('camera')
    const gridBars = inject('gridBars')

    const props = defineProps({
        volume: Number
    })

    let animationId
    let meshes = []
    

    onMounted(() => {
        watch(() => gridBars.value, (val) => {
            if (val) {
                if(camera) {
                    camera.position.set(30,30,30)
                    camera.lookAt(0,0,0)
                }

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
                        let distance = mesh.position.distanceTo({ x: 0, y: 0, z: 0 });

                        let offset = mapRange(distance, 0, 30, 5, -5);
                        let mappedDistance = mapRange(distance, 0, 30, 1, 0)
                        let mappedVolume = mapRange(props.volume, 0, 50, 0, 2)

                        let rippleRadius = props.volume; 
                            
                        let angle = (rippleRadius - distance) * 0.1 + time * 0.5 + offset ;
                        mesh.scale.set(1, (lerp(mesh.scale.y, Math.sin(angle), 0.08) - (mappedDistance * 0.5) * mappedVolume), 1); // Create the ripple effect

                    });

                    requestAnimationFrame(animate);
                };
                
                animationId = requestAnimationFrame(animate)
            } else if (!val) {
                cancelAnimationFrame(animationId)

                meshes.forEach((mesh) => {
                    scene.remove(mesh)
                })

                camera.position.set(0,0,50)
                camera.lookAt(0,0,0)
            }
        })
    })
</script>
<style lang="">
    
</style>
<script setup>
    import * as THREE from 'three'
    import {inject, onMounted, defineProps} from 'vue'
    import fragmentShader from '../../../shaders/particles/fragment.glsl'
    import vertexShader from '../../../shaders/particles/vertex.glsl'
import { GLTFLoader } from 'three/examples/jsm/Addons.js'

    const props = defineProps({
        volume: Number
    })

    const scene = inject("scene")
    let animationId, animate, material, cube

    const sizes = {
        width: window.innerWidth,
        height: window.innerHeight,
        pixelRatio: Math.min(window.devicePixelRatio, 2)
    }

    onMounted(() => {
        const loader = new GLTFLoader();
                loader.load(
                    '/models/volume-full.glb', 
                    (gltf) => {
                        gltf.scene.scale.set(100, 100, 100);
                        scene.add(gltf.scene)
                        console.log(gltf)
                        const geometry = gltf.scene.children[0].geometry
                        material = new THREE.ShaderMaterial({
                            fragmentShader,
                            vertexShader,
                            uniforms:
                            {
                                uSize: new THREE.Uniform(0.002),
                                uTime: new THREE.Uniform(0),
                                uVolume: new THREE.Uniform(0),
                                uResolution: new THREE.Uniform(new THREE.Vector2(sizes.width * sizes.pixelRatio, sizes.height * sizes.pixelRatio))
                            },
                            blending: THREE.AdditiveBlending,
                            depthWrite: false
                        })
                        const points = new THREE.Points(geometry, material)
                        scene.add(points);

                        const animate = () => {

                            requestAnimationFrame(animate)
                        }

                        animationId = requestAnimationFrame(animate)
                    },
                    undefined, 
                    (error) => {
                    console.error('An error occurred while loading the model:', error);
                    }
                );
    })
</script>
<template lang="">
    <div>
        
    </div>
</template>
<style lang="">
    
</style>
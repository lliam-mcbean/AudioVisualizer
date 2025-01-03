<template lang="">
    <div>
        
    </div>
</template>
<script setup>
    import { inject, onMounted } from 'vue';
    import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';
    import * as THREE from 'three';
    import fragmentShader from '../../../shaders/normalize/fragment.glsl'
    import vertexShader from '../../../shaders/normalize/vertex.glsl'

    const props = defineProps({
        volume: Number,
        time: Number
    });

    const scene = inject('scene');
    let material

    console.log(props.volume)

    onMounted(() => {
       if (scene) {
        const loader = new GLTFLoader();
        loader.load(
            '/models/suzanne.glb', 
            (gltf) => {
                gltf.scene.scale.set(100, 100, 100);
                scene.add(gltf.scene)
                const geometry = gltf.scene.children[0].geometry
                material = new THREE.ShaderMaterial({
                    fragmentShader,
                    vertexShader, 
                    uniforms: {
                        uVolume: {value: props.volume},
                        uTime: {value: props.time},
                        uColor: {value: new THREE.Color('#7bcceb')},
                    },
                    transparent: true
                });
                const cube = new THREE.Mesh(geometry, material);
                scene.add(cube);
            },
            undefined, 
            (error) => {
            console.error('An error occurred while loading the model:', error);
            }
        );
       }

       const animate = () => {
        console.log(props.time)

        if (material) {
            const volumeLerp = THREE.MathUtils.lerp(
                material.uniforms.uVolume.value,
                props.volume * 0.1, 
                0.1
            );
            material.uniforms.uVolume.value = volumeLerp
        }

        requestAnimationFrame(animate)
       }

       animate()
    })
</script>
<style lang="">
    
</style>
<script setup>
    import * as THREE from 'three'
    import {inject, onMounted, defineProps} from 'vue'
    import fragmentShader from '../../../shaders/particles/fragment.glsl'
    import vertexShader from '../../../shaders/particles/vertex.glsl'

    const props = defineProps({
        volume: Number
    })

    const scene = inject("scene")
    let animationId

    const sizes = {
        width: window.innerWidth,
        height: window.innerHeight,
        pixelRatio: Math.min(window.devicePixelRatio, 2)
    }

    onMounted(() => {
        const sphere = {}
        sphere.geometry = new THREE.TorusKnotGeometry(10,3,100, 10)
        sphere.geometry.setIndex(null)
        sphere.material = new THREE.ShaderMaterial({
            fragmentShader,
            vertexShader,
            uniforms:
            {
                uSize: new THREE.Uniform(0.2),
                uTime: new THREE.Uniform(0),
                uVolume: new THREE.Uniform(0),
                uResolution: new THREE.Uniform(new THREE.Vector2(sizes.width * sizes.pixelRatio, sizes.height * sizes.pixelRatio))
            },
            blending: THREE.AdditiveBlending,
            depthWrite: false
        })

        sphere.points = new THREE.Points(sphere.geometry, sphere.material)
        scene.add(sphere.points)

        console.log('this is points: ', sphere.points)
        const clock = new THREE.Clock()
        const animate = () => {
            const time = clock.getElapsedTime()

            sphere.points.geometry.attributes.position.array.map((el) => el + (Math.random() - 0.5))

            sphere.material.uniforms.uTime.value = time
            sphere.material.uniforms.uVolume.value = props.volume

            requestAnimationFrame(animate)
        }

        animationId = requestAnimationFrame(animate)
    })
</script>
<template lang="">
    <div>
        
    </div>
</template>
<style lang="">
    
</style>
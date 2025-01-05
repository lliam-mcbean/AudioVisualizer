<script setup>
    import * as THREE from 'three'
    import {inject, onMounted} from 'vue'
    import fragmentShader from '../../../shaders/particles/fragment.glsl'
    import vertexShader from '../../../shaders/particles/vertex.glsl'

    const scene = inject("scene")
    let animationId

    const sizes = {
        width: window.innerWidth,
        height: window.innerHeight,
        pixelRatio: Math.min(window.devicePixelRatio, 2)
    }

    onMounted(() => {
        const sphere = {}
        sphere.geometry = new THREE.SphereGeometry(3)
        sphere.geometry.setIndex(null)
        sphere.material = new THREE.ShaderMaterial({
            fragmentShader,
            vertexShader,
            uniforms:
            {
                uSize: new THREE.Uniform(0.2),
                uTime: new THREE.Uniform(0),
                uResolution: new THREE.Uniform(new THREE.Vector2(sizes.width * sizes.pixelRatio, sizes.height * sizes.pixelRatio))
            },
            blending: THREE.AdditiveBlending,
            depthWrite: false
        })

        sphere.points = new THREE.Points(sphere.geometry, sphere.material)
        scene.add(sphere.points)

        const clock = new THREE.Clock()
        const animate = () => {
            const time = clock.getElapsedTime()

            sphere.material.uniforms.uTime.value = time

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
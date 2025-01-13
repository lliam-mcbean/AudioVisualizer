<template lang="">
    <div>
        
    </div>
</template>
<script setup>
    import { onMounted, inject, defineProps, watch } from 'vue';
    import * as THREE from 'three'
    import fragmentShader from '../../../shaders/fire/fragment.glsl'
    import vertexShader from  '../../../shaders/fire/vertex.glsl'

    const scene =  inject('scene')
    const fire = inject('fire')
    const props = defineProps({
        volume: Number
    })

    let animationId, mesh

    onMounted(() => {
        watch(() => fire.value, (val) => {
            if (val) {
                const geometry = new THREE.PlaneGeometry(30,30,100,100)
        const material = new THREE.ShaderMaterial({
            fragmentShader,
            vertexShader,
            side: THREE.DoubleSide,
            uniforms: {
                uTime: {value: 0},
                uMouse: {value: new THREE.Vector2(0,0)},
                uResolution: {value: new THREE.Vector2(window.innerWidth, window.innerHeight)},
                uVelocity: {value: 3},
                uColor1: {value: new THREE.Color("#ff801a")},
                uColor2: {value: new THREE.Color("#ff5718")}

            }
        })
        mesh  = new THREE.Mesh(geometry, material)
        scene.add(mesh)

        console.log('color: ', new THREE.Color("#ff5718"))

        const clock = new THREE.Clock()
        const animate = () => {
            const time = clock.getElapsedTime()

            material.uniforms.uTime.value = time
            material.uniforms.uColor1.value.b = THREE.MathUtils.lerp(
                material.uniforms.uColor1.value.b,
                props.volume / 5,
                0.1
            )
            material.uniforms.uVelocity.value = THREE.MathUtils.lerp(
                material.uniforms.uVelocity.value,
                3 + props.volume / 80,
                0.01
            )
            mesh.scale.x = THREE.MathUtils.lerp(mesh.scale.x, 1 + props.volume / 30, 0.1)


            requestAnimationFrame(animate)
        }

        animationId = requestAnimationFrame(animate)
            } else if (!val && animationId) {

                scene.remove(mesh)

                cancelAnimationFrame(animationId)
            }
        })
    })
</script>
<style lang="">
    
</style>
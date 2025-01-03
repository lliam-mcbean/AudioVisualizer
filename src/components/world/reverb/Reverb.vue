<template lang="">
    <div>
        
    </div>
</template>
<script setup>
    import { inject, onMounted, defineProps } from 'vue';
    import * as THREE from 'three'
    import fragmentShader from '../../../shaders/reverb/fragment.glsl'
    import vertexShader from '../../../shaders/reverb/vertex.glsl'
    import starFragmentShader from '../../../shaders/star/fragment.glsl'
    import starVertexShader from '../../../shaders/star/vertex.glsl'

    const scene = inject('scene')

    const props = defineProps({
        volume: Number,
        time: Number
    })

    let material, material2, material3
    
    onMounted(() => {
        const geometry = new THREE.PlaneGeometry(20,1,1000,1000)
        material = new THREE.ShaderMaterial({
            fragmentShader,
            vertexShader,
            uniforms: {
                uSpeedFactor: {value: props.volume},
                uTime: {value: props.time}
            },
            transparent: true
        })
        const mesh = new THREE.Mesh(geometry, material)
        mesh.position.set(10, 0, 0)
        scene.add(mesh)

        const geometry2 = new THREE.PlaneGeometry(20,1,1000,1000)
        material2 = new THREE.ShaderMaterial({
            fragmentShader,
            vertexShader,
            uniforms: {
                uSpeedFactor: {value: props.volume},
                uTime: {value: props.time}
            },
            toneMapped: false,
            transparent: true
        })
        const mesh2 = new THREE.Mesh(geometry2, material2)
        mesh2.position.set(-10,0,0)
        mesh2.rotation.set(0,0,Math.PI)
        scene.add(mesh2)

        const geometry3 = new THREE.PlaneGeometry(400,400)
        material3 = new THREE.ShaderMaterial({
            fragmentShader: starFragmentShader,
            vertexShader: starVertexShader,
            uniforms: {
                uSpeedFactor: {value: props.volume},
                uTime: {value: props.time}
            },
            transparent: true,
            toneMapped: false
        })
        const mesh3 = new THREE.Mesh(geometry3, material3)
        scene.add(mesh3)

        const lerp = (start, end, t) => {
            return start + (end - start) * t;
        };

        const animate = () => {
            if (material &&  material2) {
                material.uniforms.uSpeedFactor.value = lerp(material.uniforms.uSpeedFactor.value, props.volume * 0.01, 0.08) 
                material.uniforms.uTime.value = props.time

                material2.uniforms.uSpeedFactor.value = lerp(material2.uniforms.uSpeedFactor.value, props.volume * 0.01, 0.08) 
                material2.uniforms.uTime.value = props.time


                mesh3.scale.set(lerp(mesh3.scale.x, 1 + (props.volume * 0.06), 0.08), lerp(mesh3.scale.y, 1 + (props.volume * 0.06), 0.08), lerp(mesh3.scale.z, 1 + (props.volume * 0.06), 0.08))
            }

            requestAnimationFrame(animate)
        }

        animate()
    })
</script>
<style lang="">
    
</style>
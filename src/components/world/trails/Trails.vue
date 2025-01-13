<script setup>
    import * as THREE from 'three'
    import {inject, onMounted, defineProps, watch} from 'vue'
    import fragmentShader from '../../../shaders/particles/fragment.glsl'
    import vertexShader from '../../../shaders/particles/vertex.glsl'
import { GLTFLoader } from 'three/examples/jsm/Addons.js'

    const props = defineProps({
        volume: Number
    })

    const scene = inject("scene")
    const isParticles = inject("particles")
    let animationId, animate, material, cube
    let particles  = {}

    const loader = new GLTFLoader()

    const sizes = {
        width: window.innerWidth,
        height: window.innerHeight,
        pixelRatio: Math.min(window.devicePixelRatio, 2)
    }

    onMounted(() => {
        watch(() => isParticles.value, (val) => {
            console.log(isParticles.value)
            if (val) {
                loader.load('./models/suzanne.glb', (gltf) => {
            const geometry = gltf.scene.children[0].geometry.clone()
            geometry.scale(10,10,10) 

            particles.geometries = [new THREE.TorusKnotGeometry(2, 10, 250, 10), geometry]
            particles.geometry  = new THREE.BufferGeometry()
            particles.material = new THREE.ShaderMaterial({
                fragmentShader,
                vertexShader,
                uniforms: {
                    uResolution: {value: new THREE.Vector2(sizes.width * sizes.pixelRatio, sizes.height * sizes.pixelRatio)},
                    uSize: {value: 0.2},
                    uProgress: {value: 0},
                    uColorA: new THREE.Uniform(new THREE.Color('#7bcceb')),
                    uColorB: new THREE.Uniform(new THREE.Color('#ff7300'))
                },
                transparent: true,
                blending: THREE.AdditiveBlending,
                depthWrite: false
            })

            particles.positions = []
            particles.maxCount = particles.geometries[1].attributes.position.count
            particles.geometries.forEach((el) => {
                const newArray  = new Float32Array(particles.maxCount * 3)
                console.log(el)
                const oldArray = el.attributes.position.array

                for(let i = 0; i < particles.maxCount; i++) {
                    const i3 = i*3

                    if(i3 < oldArray.length)
                    {
                        newArray[i3 + 0] = oldArray[i3 + 0]
                        newArray[i3 + 1] = oldArray[i3 + 1]
                        newArray[i3 + 2] = oldArray[i3 + 2]
                    }
                    else
                    {
                        const randomIndex = Math.floor(el.attributes.position.count * Math.random()) * 3
                        newArray[i3 + 0] = oldArray[randomIndex + 0]
                        newArray[i3 + 1] = oldArray[randomIndex + 1]
                        newArray[i3 + 2] = oldArray[randomIndex + 2]
                    }
                }

                particles.positions.push(new THREE.Float32BufferAttribute(newArray, 3))
            })

            console.log('particles: ', particles.positions)
            particles.geometry.setAttribute('position', particles.positions[0])
            particles.geometry.setAttribute('aPositionTarget', particles.positions[1])
            particles.points = new THREE.Points(particles.geometry, particles.material)
            scene.add(particles.points)

        })

        function remap(value, inMin, inMax, outMin, outMax) {   
            const clampedValue = Math.max(inMin, Math.min(value, inMax));
            return outMin + ((clampedValue - inMin) / (inMax - inMin)) * (outMax - outMin);
        }

        const animate = () => {
            if (particles.material) {
                particles.material.uniforms.uProgress.value = THREE.MathUtils.lerp(particles.material.uniforms.uProgress.value, remap(props.volume, 0, 20, 0, 1), 0.1)
            }


            requestAnimationFrame(animate)
        }

        animationId = requestAnimationFrame(animate)

            } else if (!val && animationId) {
                scene.remove(particles.points)
                particles = {}

                cancelAnimationFrame(animationId)
            }
        })
    })
</script>
<template lang="">
    <div>
        
    </div>
</template>
<style lang="">
    
</style>
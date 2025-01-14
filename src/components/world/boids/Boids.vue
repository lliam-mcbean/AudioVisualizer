<template lang="">
    <div>
        
    </div>
</template>
<script setup>
    import { inject, onMounted, watch } from 'vue';
    import { Boid } from './boid';

    const scene = inject('scene')
    const boids = inject('boids')
    const camera = inject('camera')
    const props = defineProps({
        volume: Number
    })

    let animationId
    let flock = []

    onMounted(() => {
        watch(() => boids.value, (val) => {
            if (val) {
                camera.position.set(0,0,100) 
                for (let i = 0; i < 1000; i++) {
                    flock.push(new Boid)
                    flock[i].show()
                    scene.add(flock[i].mesh)
                }

                function remap(value, inMin, inMax, outMin, outMax) {   
                    const clampedValue = Math.max(inMin, Math.min(value, inMax));
                    return outMin + ((clampedValue - inMin) / (inMax - inMin)) * (outMax - outMin);
                }


                const animate = () => {
                    for (let bird of flock) {
                        bird.update()
                        bird.flock(flock)
                        bird.edges()
                        
                        bird.cohesionForce = remap(props.volume, 0, 20, 0.009, 0.15)
                        bird.seperationForce = remap(props.volume, 0, 20, 0.09, 0.13)
                        bird.alignForce = remap(props.volume, 0, 20, 0.009, 0.15)
                        bird.radius = props.volume / 2
                    }

                    requestAnimationFrame(animate)
                }

                animationId = requestAnimationFrame(animate)
            } else if (!val && animationId) {
                camera.position.set(0,0,50)

                for (let bird of flock) {
                    scene.remove(bird.mesh)
                }

                flock = []


                cancelAnimationFrame(animationId)
            }
        })
    })

</script>
<style lang="">
    
</style>
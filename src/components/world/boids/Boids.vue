<template lang="">
    <div>
        
    </div>
</template>
<script setup>

    import { inject, onMounted } from 'vue';
    import * as THREE from 'three'

    const scene = inject('scene')
    let animationId

    class Boid {
        constructor() {
            this.maxForce = 0.1
            this.maxSpeed = 0.5
            this.position = new THREE.Vector3((Math.random() - 0.5) * 60, (Math.random() - 0.5) * 60, 0)
            this.velocity = new THREE.Vector3(Math.random() - 0.5,Math.random() - 0.5,0).normalize().multiplyScalar(0.1)
            this.acceleration = new THREE.Vector3(0,0,0)
            this.mesh = new THREE.Mesh()
        }

        edges() {
            if (this.position.x > 50) {
                this.position.x = -50
            } else if (this.position.x < -50) {
                this.position.x = 50
            }
            if (this.position.y > 50) {
                this.position.y = -50
            } else if (this.position.y < -50) {
                this.position.y = 50
            }
        }

        align(boids) {
            let avg = new THREE.Vector3(0)
            let total = 0    

            for (let other of boids) {
                if (this.position.distanceTo(other.position) < 8 && other !== this) {
                    avg.add(other.velocity)
                    total++
                }
            }

            if (total > 0) {
                avg.divideScalar(total)
                // steering
                avg.setLength(this.maxSpeed)
                avg.sub(this.velocity)
                avg.clampLength(0, this.maxForce)
            }

            return avg

        }

        seperation(boids) {
            let avg = new THREE.Vector3(0)
            let total = 0   

            for (let other of boids) {
                let distance = this.position.distanceTo(other.position) 
                if (distance < 10 && other !== this) {
                    let diff = new THREE.Vector3().copy(this.position)
                    diff.sub(other.position)
                    diff.divideScalar(distance)
                    avg.add(diff)
                    total++
                }
            }

            if (total > 0) {
                avg.divideScalar(total)
                // steering
                avg.setLength(this.maxSpeed)
                avg.sub(this.velocity)
                avg.clampLength(0, this.maxForce)
            }

            return avg

        }

        cohesion(boids) {
            let avg = new THREE.Vector3(0)
            let total = 0    

            for (let other of boids) {
                if (this.position.distanceTo(other.position) < 8 && other !== this) {
                    avg.add(other.position)
                    total++
                }
            }

            if (total > 0) {
                avg.divideScalar(total)
                avg.sub(this.position)
                // steering
                avg.setLength(this.maxSpeed)
                avg.sub(this.velocity)
                avg.clampLength(0, this.maxForce)
            }

            return avg

        }

        flock(boids) {
            this.acceleration.multiplyScalar(0)
            let alignment = this.align(boids)
            let cohesion = this.cohesion(boids)
            let seperation = this.seperation(boids)
            this.acceleration.add(seperation)
            this.acceleration.add(alignment)
            this.acceleration.add(cohesion)
        }

        show() {
            const geometry = new THREE.SphereGeometry(0.5)
            const material = new THREE.MeshBasicMaterial({color: 'red'})
            this.mesh.geometry = geometry
            this.mesh.material = material
            this.mesh.position.add(this.position)
            scene.add(this.mesh)
        }

        update() {
            this.position.add(this.velocity)
            this.velocity.add(this.acceleration)

            this.mesh.position.copy(this.position)
        }
    }

    onMounted(() => {
        let flock = []

        for (let i = 0; i < 100; i++) {
            flock.push(new Boid)
            flock[i].show()
        }
        

        const animate = () => {
            for (let bird of flock) {
                bird.update()
                bird.flock(flock)
                bird.edges()
            }

            requestAnimationFrame(animate)
        }

        animationId = requestAnimationFrame(animate)
    })

</script>
<style lang="">
    
</style>
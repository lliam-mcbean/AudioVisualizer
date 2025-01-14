import * as THREE from 'three'
import fragmentShader from '../../../shaders/antialias/fragment.glsl'
import vertexShader from '../../../shaders/antialias/vertex.glsl'

export class Boid {
    constructor() {
        this.radius = 20
        this.cohesionForce = 0.01
        this.seperationForce = 0.01
        this.alignForce = 0.01
        this.maxSpeed = 0.8
        this.position = new THREE.Vector3((Math.random() - 0.5) * 80, (Math.random() - 0.5) * 80, (Math.random() - 0.5) * 80)
        this.velocity = new THREE.Vector3(Math.random() - 0.5,Math.random() - 0.5,Math.random() - 0.5).normalize().multiplyScalar(0.1)
        this.acceleration = new THREE.Vector3(0,0,0)
        this.mesh = new THREE.Mesh()
    }

    edges() {
        if (this.position.x > 75) {
            this.position.x = -75
        } else if (this.position.x < -75) {
            this.position.x = 75
        }
        if (this.position.y > 75) {
            this.position.y = -75
        } else if (this.position.y < -75) {
            this.position.y = 75
        }
        if (this.position.z > 50) {
            this.position.z = -50
        } else if (this.position.z < -50)  {
            this.position.z = 50
        }
    }

    align(boids) {
        let avg = new THREE.Vector3(0)
        let total = 0    

        for (let other of boids) {
            if (this.position.distanceTo(other.position) < this.radius && other !== this) {
                avg.add(other.velocity)
                total++
            }
        }

        if (total > 0) {
            avg.divideScalar(total)
            // steering
            avg.setLength(this.maxSpeed)
            avg.sub(this.velocity)
            avg.clampLength(0, this.alignForce)
        }

        return avg

    }

    seperation(boids) {
        let avg = new THREE.Vector3(0)
        let total = 0  

        for (let other of boids) {
            let distance = this.position.distanceTo(other.position) 
            if (distance < this.radius && other !== this) {
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
            avg.clampLength(0, this.seperationForce)
        }

        return avg

    }

    cohesion(boids) {
        let avg = new THREE.Vector3(0)
        let total = 0    

        for (let other of boids) {
            if (this.position.distanceTo(other.position) < this.radius && other !== this) {
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
            avg.clampLength(0, this.cohesionForce)
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
        const geometry = new THREE.ConeGeometry(0.5, 0.5, 3, 1)
        const material = new THREE.ShaderMaterial({
            fragmentShader,
            vertexShader,
            uniforms: {
                thickness: {value: 2}
            }
        })
        this.mesh.geometry = geometry
        this.mesh.material = material
        this.mesh.position.add(this.position)
    }

    update() {
        this.position.add(this.velocity)
        this.velocity.add(this.acceleration)

        this.mesh.position.copy(this.position)
        
        let direction = new THREE.Vector3().copy(this.velocity)
        const spherical = new THREE.Spherical().setFromVector3(direction);
        this.mesh.rotation.set(spherical.phi, spherical.theta, 0);
    }
}

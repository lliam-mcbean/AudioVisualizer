<script setup>
    import { onMounted, inject, watch } from 'vue';
    import * as THREE from 'three'
    import fragmentShader from '../../../shaders/threealias/fragment.glsl'
    import vertexShader from '../../../shaders/threealias/vertex.glsl'
    import { Line2 } from 'three/examples/jsm/lines/webgpu/Line2.js';
import { LineGeometry, LineMaterial } from 'three/examples/jsm/Addons.js';


    const scene = inject('scene')
    const score = inject('score')
    const message = inject('message')
    const isCubeSnake = inject('cubeSnake')
    const camera = inject('camera')

    let animationId
    let snake = {}
    let food = {}
    let world = {}


  const points = [
    [15, 15, 0],
    [15, -15, 0],
    [-15, -15, 0],
    [-15, 15, 0],
    [15, 15, 0],
    [15, 15, -30],
    [-15, 15, -30],
    [-15, -15, -30],
    [15, -15, -30],
    [15, 15, -30],
    [15, -15, -30],
    [15, -15, 0],
    [-15, -15, 0],
    [-15, -15, -30],
    [-15, 15, -30],
    [-15, 15, 0]
  ]

    const faces = {
        1: true,
        2: false,
        3: false,
        4: false,
        5: false,
        6: false
    }

    const direction = new THREE.Vector3(0, 1, 0)
    let keyListener

    watch(() => message.value, (val) => {
        const words = val.toLowerCase().split(' ')

        if (words.includes('up')) {
            direction.set(0,1,0)
        }
        if (words.includes('down')) {
            direction.set(0,-1,0)
        }
        if (words.includes('right')) {
            direction.set(1,0,0)
        }
        if (words.includes('left')) {
            direction.set(-1,0,0)
        }
    })

    const resetGame = () => {
        const segment = snake.meshes[0]
        segment.position.set(0,0,0)

        snake.meshes.forEach((mesh) => scene.remove(mesh))
        snake.meshes = [segment]
        snake.nextPosition = []

        scene.add(snake.meshes[0])
        faces[1] = true
        faces[2] = false
        faces[3] = false
        faces[4] = false
        faces[5] = false
        faces[6] = false
    }

    keyListener = (event) => {
        if (event.key === 'ArrowUp') {
            if (faces[1] || faces[3] || faces[5] || faces[6]) {
                direction.set(0,1,0)
            }
            if (faces[2] || faces[4]) {
                direction.set(0,0,-1)
            }
        }
        if (event.key === 'ArrowDown') {
            if (faces[1] || faces[3] || faces[5] || faces[6]) {
                direction.set(0,-1,0)
            }
            if (faces[2] || faces[4]) {
                direction.set(0,0,1)
            }
        }
        if (event.key === 'ArrowLeft') {
            if (faces[1] || faces[2] || faces[3] || faces[4]) {
                direction.set(-1,0,0)
            }
            if (faces[5] || faces[6]) {
                direction.set(0,0,1)
            }
        }
        if (event.key === 'ArrowRight') {
            if (faces[1] || faces[2] || faces[3] || faces[4]) {
                direction.set(1,0,0)
            }
            if (faces[5] || faces[6]) {
                direction.set(0,0,-1)
            }
        }
    }

    window.addEventListener('keydown', keyListener)

    onMounted(() => {
        watch(() => isCubeSnake.value, (val) => {
            if (val) {
                if (camera) {
                    camera.position.set(30,30,30)
                    camera.lookAt(0,0,-15)
                }
                food.geometry = new THREE.BoxGeometry(0.9, 0.9, 0.9)
                food.material = new THREE.MeshBasicMaterial({color:  'red'})
                food.mesh = new THREE.Mesh(food.geometry, food.material)
                food.mesh.position.set(Math.floor((Math.random() - 0.5) * 30), Math.floor((Math.random() - 0.5) * 30), 0)

                
                world.material = new LineMaterial({
                    color: '#7bcceb',
                    linewidth: 0.002
                });
                world.points =  points.map((el)  => new THREE.Vector3(...el))
                world.geometry = new LineGeometry().setFromPoints(world.points)
                world.cube = new THREE.Mesh(
                    new THREE.BoxGeometry(30, 30, 30),
                    new THREE.ShaderMaterial({
                        fragmentShader,
                        vertexShader,
                        transparent: true,
                        depthWrite: true,
                        blending: THREE.AdditiveBlending
                    })
                )
                world.cube.position.set(0,0,-15)
                world.mesh = new Line2(world.geometry, world.material)

                snake.geometry = new THREE.BoxGeometry(0.9, 0.9, 0.9)
                snake.material = new THREE.MeshBasicMaterial({color:  'green'})
                snake.meshes = [new THREE.Mesh(snake.geometry, snake.material)]
                scene.add(snake.meshes[0], food.mesh, world.mesh, world.cube)

                snake.nextPosition = []

                let frameCount = 0

                const animate = () => {
                    frameCount++

                    if (frameCount % 10 === 0) {
                        for (let i = 0; i < snake.meshes.length; i++) {
                            const mesh = snake.meshes[i]
                            if (i === 0) {
                                snake.nextPosition[i] = [mesh.position.x, mesh.position.y, mesh.position.z] 
                                mesh.position.set(mesh.position.x + direction.x, mesh.position.y + direction.y, mesh.position.z + direction.z)

                                if (mesh.position.equals(food.mesh.position)) {
                                    const random = Math.random() * 6; 

                                    if (random < 1) {
                                        food.mesh.position.set(Math.floor((Math.random() - 0.5) * 30), Math.floor((Math.random() - 0.5) * 30), 0)
                                    }
                                    if (random < 2 && random > 1) {
                                        food.mesh.position.set(Math.floor((Math.random() - 0.5) * 30), 15, -Math.floor((Math.random()) * 30))
                                    }
                                    if (random < 3 && random > 2) {
                                        food.mesh.position.set(Math.floor((Math.random() - 0.5) * 30), Math.floor((Math.random() - 0.5) * 30), -30)
                                    }
                                    if (random < 4 && random > 3) {
                                        food.mesh.position.set(Math.floor((Math.random() - 0.5) * 30), 15, -Math.floor((Math.random()) * 30))
                                    }
                                    if (random < 5 && random > 4) {
                                        food.mesh.position.set(-15, Math.floor((Math.random() - 0.5) * 30), -Math.floor((Math.random()) * 30))
                                    }
                                    if (random < 6 && random > 5) {
                                        food.mesh.position.set(15, Math.floor((Math.random() - 0.5) * 30), -Math.floor((Math.random()) * 30))
                                    }

                                    const segment = new THREE.Mesh(snake.geometry, snake.material)
                                    segment.position.set(snake.meshes[snake.meshes.length - 1].position.x - direction.x, snake.meshes[snake.meshes.length - 1].position.y - direction.y, 0 )

                                    snake.nextPosition = [...snake.nextPosition, [snake.meshes[snake.meshes.length - 1].position.x, snake.meshes[snake.meshes.length - 1].position.y, snake.meshes[snake.meshes.length - 1].position.z]]
                                    snake.meshes = [...snake.meshes, segment]
                                    scene.add(snake.meshes[snake.meshes.length - 1])
                                }

                                if (faces[1]) {
                                    if (mesh.position.y === 15) {
                                        direction.set(0,0,-1)
                                        faces[1] = false
                                        faces[2] = true
                                        break
                                    }
                                    if(mesh.position.y === -15) {
                                        direction.set(0,0,-1)
                                        faces[1] = false
                                        faces[4] = true
                                        break
                                    }
                                    if(mesh.position.x === -15) {
                                        direction.set(0,0,-1)
                                        faces[1] = false
                                        faces[5] = true
                                        break
                                    }
                                    if(mesh.position.x === 15) {
                                        direction.set(0,0,-1)
                                        faces[1] = false
                                        faces[6] = true
                                        break
                                    }
                                }

                                if (faces[2]) {
                                    if (mesh.position.z === -30) {
                                        direction.set(0,-1,0)
                                        faces[2] = false
                                        faces[3] = true
                                        break
                                    }
                                    if(mesh.position.z === 0) {
                                        direction.set(0,-1,0)
                                        faces[2] = false
                                        faces[1] = true
                                        break
                                    }
                                    if(mesh.position.x === -15) {
                                        direction.set(0,-1,0)
                                        faces[2] = false
                                        faces[5] = true
                                        break
                                    }
                                    if(mesh.position.x === 15) {
                                        direction.set(0,-1,0)
                                        faces[2] = false
                                        faces[6] = true
                                        break
                                    }
                                }

                                
                                if (faces[3]) {
                                    if (mesh.position.y === 15) {
                                        direction.set(0,0,1)
                                        faces[3] = false
                                        faces[2] = true
                                        break
                                    }
                                    if(mesh.position.y === -15) {
                                        direction.set(0,0,1)
                                        faces[3] = false
                                        faces[4] = true
                                        break
                                    }
                                    if(mesh.position.x === -15) {
                                        direction.set(0,0,1)
                                        faces[3] = false
                                        faces[5] = true
                                        break
                                    }
                                    if(mesh.position.x === 15) {
                                        direction.set(0,0,1)
                                        faces[3] = false
                                        faces[6] = true
                                        break
                                    }
                                }

                                if (faces[4]) {
                                    if (mesh.position.z === -30) {
                                        direction.set(0,1,0)
                                        faces[4] = false
                                        faces[3] = true
                                        break
                                    }
                                    if(mesh.position.z === 0) {
                                        direction.set(0,1,0)
                                        faces[4] = false
                                        faces[1] = true
                                        break
                                    }
                                    if(mesh.position.x === -15) {
                                        direction.set(0,1,0)
                                        faces[4] = false
                                        faces[5] = true
                                        break
                                    }
                                    if(mesh.position.x === 15) {
                                        direction.set(0,1,0)
                                        faces[4] = false
                                        faces[6] = true
                                        break
                                    }
                                }
                                if (faces[5]) {
                                    if (mesh.position.z === -30) {
                                        direction.set(1,0,0)
                                        faces[5] = false
                                        faces[3] = true
                                        break
                                    }
                                    if(mesh.position.z === 0) {
                                        direction.set(1,0,0)
                                        faces[5] = false
                                        faces[1] = true
                                        break
                                    }
                                    if(mesh.position.y === -15) {
                                        direction.set(1,0,0)
                                        faces[5] = false
                                        faces[4] = true
                                        break
                                    }
                                    if(mesh.position.y === 15) {
                                        direction.set(1,0,0)
                                        faces[5] = false
                                        faces[2] = true
                                        break
                                    }
                                }

                                if (faces[6]) {
                                    if (mesh.position.z === -30) {
                                        direction.set(-1,0,0)
                                        faces[6] = false
                                        faces[3] = true
                                        break
                                    }
                                    if(mesh.position.z === 0) {
                                        direction.set(-1,0,0)
                                        faces[6] = false
                                        faces[1] = true
                                        break
                                    }
                                    if(mesh.position.y === -15) {
                                        direction.set(-1,0,0)
                                        faces[6] = false
                                        faces[4] = true
                                        break
                                    }
                                    if(mesh.position.y === 15) {
                                        direction.set(-1,0,0)
                                        faces[6] = false
                                        faces[2] = true
                                        break
                                    }
                                }
                                console.log(snake.nextPosition[0])

                                for (let j = 0; j < snake.meshes.length; j++) {
                                    let comparedMesh = snake.meshes[j]
                                    if (comparedMesh.position.equals(mesh.position) && i !== j) {
                                        resetGame()
                                    }
                                }
                            } else if (i === snake.nextPosition.length) {
                                mesh.position.set(...snake.nextPosition[i - 1])
                            } else {
                                snake.nextPosition[i] = [mesh.position.x, mesh.position.y, mesh.position.z]
                                mesh.position.set(...snake.nextPosition[i - 1])
                            }
                        }
                        score.value = snake.meshes.length - 1
                    }

                    requestAnimationFrame(animate)
                }

                animationId = requestAnimationFrame(animate)
            } else if (!val && keyListener) {
                window.removeEventListener('keydown', keyListener)
                cancelAnimationFrame(animationId)

                snake.meshes.forEach((mesh) => scene.remove(mesh))
                scene.remove(food.mesh, world.mesh, world.cube)

                camera.position.set(0,0,50)
                camera.lookAt(0,0,0)

                food = {}
                snake = {}
                world = {}

                score.value = null
            }
        })
    })
</script>
<template lang="">
</template>
<style lang="">
    
</style>
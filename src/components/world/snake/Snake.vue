<script setup>
    import { onMounted, inject, watch } from 'vue';
    import * as THREE from 'three'


    const scene = inject('scene')
    const score = inject('score')
    const message = inject('message')
    const isSnake = inject('snake')

    let animationId
    let snake = {}
    let food = {}
    let world = {}

    const direction = new THREE.Vector3(-1, 0, 0)
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

    onMounted(() => {
        watch(() => isSnake.value, (val) => {
            if (val) {
                food.geometry = new THREE.BoxGeometry(0.9, 0.9, 0.01)
                food.material = new THREE.MeshBasicMaterial({color:  'red'})
                food.mesh = new THREE.Mesh(food.geometry, food.material)
                food.mesh.position.set(Math.floor((Math.random() - 0.5) * 30), Math.floor((Math.random() - 0.5) * 30), 0)

                world.geometry = new THREE.PlaneGeometry(30.7, 30.7)
                world.material = new THREE.MeshBasicMaterial({color: 'white'})
                world.mesh = new THREE.Mesh(world.geometry, world.material)

                snake.geometry = new THREE.BoxGeometry(0.9, 0.9, 0.01)
                snake.material = new THREE.MeshBasicMaterial({color:  'green'})
                snake.meshes = [new THREE.Mesh(snake.geometry, snake.material)]
                scene.add(snake.meshes[0], food.mesh, world.mesh)

                snake.nextPosition = []

                keyListener = (event) => {
                    console.log(event)
                    if (event.key === 'ArrowUp') {
                        direction.set(0,1,0)
                    }
                    if (event.key === 'ArrowDown') {
                        direction.set(0,-1,0)
                    }
                    if (event.key === 'ArrowLeft') {
                        direction.set(-1,0,0)
                    }
                    if (event.key === 'ArrowRight') {
                        direction.set(1,0,0)
                    }
                }

                window.addEventListener('keydown', keyListener)



                let frameCount = 0

                const animate = () => {
                    frameCount++

                    if (frameCount % 20 === 0) {
                        for (let i = 0; i < snake.meshes.length; i++) {
                            const mesh = snake.meshes[i]
                            if (i === 0) {
                                snake.nextPosition[i] = [mesh.position.x, mesh.position.y, mesh.position.z] 
                                mesh.position.set(mesh.position.x + direction.x, mesh.position.y + direction.y, 0)

                                if (mesh.position.equals(food.mesh.position)) {
                                    food.mesh.position.set(Math.floor((Math.random() - 0.5) * 30), Math.floor((Math.random() - 0.5) * 30), 0)

                                    const segment = new THREE.Mesh(snake.geometry, snake.material)
                                    segment.position.set(snake.meshes[snake.meshes.length - 1].position.x - direction.x, snake.meshes[snake.meshes.length - 1].position.y - direction.y, 0 )

                                    snake.nextPosition = [...snake.nextPosition, [snake.meshes[snake.meshes.length - 1].position.x, snake.meshes[snake.meshes.length - 1].position.y, snake.meshes[snake.meshes.length - 1].position.z]]
                                    snake.meshes = [...snake.meshes, segment]
                                    scene.add(snake.meshes[snake.meshes.length - 1])
                                }

                                if (Math.abs(mesh.position.x) > 15 || Math.abs(mesh.position.y) > 15) {
                                    const segment = snake.meshes[0]
                                    segment.position.set(0,0,0)

                                    snake.meshes.forEach((mesh) => scene.remove(mesh))
                                    snake.meshes = [segment]
                                    snake.nextPosition = []

                                    scene.add(snake.meshes[0])
                            
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
                scene.remove(food.mesh, world.mesh)

                food = {}
                snake = {}
                world = {}
            }
        })
    })
</script>
<template lang="">
</template>
<style lang="">
    
</style>
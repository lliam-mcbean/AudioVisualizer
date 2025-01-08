<script setup>
import { onMounted, provide, ref, defineProps } from 'vue';
import * as THREE from 'three';
import Normalize from './normalize/Normalize.vue';
import Reverb from './reverb/Reverb.vue';
import Bars from './bars/Bars.vue';
import GridBars from './gridbars/GridBars.vue';
import Trails from './trails/Trails.vue';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import Snake from './snake/Snake.vue';

const props = defineProps({
    volume: Number
})

let scene = new THREE.Scene()
let time = ref(0)
let camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
let renderer;

provide('scene', scene);
provide('camera', camera)

const initThree = () => {
  camera.position.z = 50;

  renderer = new THREE.WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
  });

  const controls = new OrbitControls(camera, renderer.domElement)
  controls.update()

  const clock = new THREE.Clock()
  const animate = () => {
    time = clock.getElapsedTime()

    requestAnimationFrame(animate);
    renderer.render(scene, camera);
  };

  animate();
};

onMounted(() => {
  initThree();
});
</script>

<template>
  <div>
    <Normalize :time="time" :volume="props.volume" />
    <Reverb :time="time" :volume="props.volume" />
    <Bars :volume="props.volume" />
    <GridBars :volume="props.volume" />
    <!-- <Trails /> -->
     <Snake />
  </div>
</template>

<style scoped>
/* Add styles for your component here */
</style>
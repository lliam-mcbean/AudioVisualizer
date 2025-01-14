<script setup>
import { computed, ref } from 'vue';
import Speech from './components/speech/Speech.vue';
import Volume from './components/volume/Volume.vue';
import World from './components/world/World.vue';
import Navigation from './components/navigation/Navigation.vue';
import { provide } from 'vue';
import { reactive } from 'vue';

const message = ref('')
const volume = ref(0)
const score = reactive({value: null})
provide('score', score)
provide('message', message)

const normalized = reactive({ value: false });
const bars = reactive({value: false})
const gridBars = reactive({value: false})
const reverb = reactive({value: false})
const snake = reactive({value: false})
const cubeSnake = reactive({value: false})
const fire = reactive({value: false})
const particles = reactive({value: false})

provide('normalized', normalized)
provide('bars', bars)
provide('gridBars', gridBars)
provide('reverb', reverb)
provide('snake', snake)
provide('cubeSnake', cubeSnake)
provide('fire', fire)
provide('particles', particles)

const shouldRenderDiv = computed(() => !normalized.value && !particles.value && !fire.value && !bars.value && !gridBars.value && !reverb.value && !snake.value && !cubeSnake.value);

const shouldProvideScore = computed(() => score.value !== null)
</script>

<template>
  <Speech v-model="message" title="" />
  <Navigation />
  <Suspense>
    <Volume v-model="volume" />
  </Suspense>
  <div class="">
    <World :volume="volume" :message="message"/>
  </div>
  <div class="fixed pb-[200px] text-center text-white w-screen top-0 flex justify-center pt-[50px]">
      <div>
        <p class="text-2xl py-8">{{ Math.round(volume * 100) / 100 }}</p>
        <p>{{ message }}</p>
      </div>
  </div>
  <div v-if="shouldRenderDiv" class="w-screen h-screen absolute top-0 left-0 flex justify-center items-center text-white text-2xl"> 
    <font-awesome-icon :icon="['fas', 'arrow-left']" />
    <div class="pl-4">
      Choose A Visualizer
    </div>
  </div>
  <div v-if="shouldProvideScore" class="w-screen h-screen absolute top-0 left-0 flex justify-center items-end p-8 text-white text-2xl"> 
    <div>Score: </div>
    <div class="pl-4">
      {{ score.value }}
    </div>
  </div>
</template>

<style scoped>

</style>

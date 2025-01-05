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

const normalized = reactive({ value: false });
const bars = reactive({value: false})
const gridBars = reactive({value: false})

provide('normalized', normalized)
provide('bars', bars)
provide('gridBars', gridBars)

const shouldRenderDiv = computed(() => 
  !normalized.value && !bars.value && !gridBars.value
);
</script>

<template>
  <Speech v-model="message" title="" />
  <Navigation />
  <Suspense>
    <Volume v-model="volume" />
  </Suspense>
  <div class="">
    <World :volume="volume" />
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
</template>

<style scoped>

</style>

<script setup>
import { ref } from 'vue';
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

provide('normalized', normalized)
provide('bars', bars)
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
</template>

<style scoped>

</style>

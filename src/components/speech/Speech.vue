<template>
    <div>
    </div>
  </template>
  
  <script setup>
        import { onMounted, onUnmounted, ref, defineProps, defineEmits } from 'vue';
  
        const props = defineProps({
            modelValue: String,
            title: String
        })

        const emit = defineEmits(['update:modelValue'])

        const onInputChange = (text) => {
            emit('update:modelValue', text)
        }

        const shouldRestart = ref(true); 
        let recognition; 
    
        onMounted(() => {
            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    
            if (!SpeechRecognition) {
            console.error('SpeechRecognition is not supported in this browser.');
            return;
            }
    
            recognition = new SpeechRecognition();

            const start = () => {
                console.log('speech has started')
                recognition.start()
            }

            recognition.continuous = true; 
    
            recognition.onresult = (event) => {
                console.log('this is the event: ', event)
            let transcript = '';
            for (let i = event.resultIndex; i < event.results.length; i++) {
                transcript += event.results[i][0].transcript;
            }
            console.log('Transcript:', transcript);
            onInputChange(transcript)
            };
    
            recognition.onend = () => {
            console.log('Speech recognition stopped.');
            if (shouldRestart.value) {
                console.log('Restarting speech recognition...');
                start();
            }
            };
    
            recognition.onerror = (event) => {
            console.error('Speech recognition error:', event.error);
            };
    
            start();
        });
    
        onUnmounted(() => {
            if (recognition) {
            shouldRestart.value = false;
            recognition.abort();
            console.log('Speech recognition aborted.');
            }
        });
  </script>
  
  <style>
  /* Add your styles here */
  </style>
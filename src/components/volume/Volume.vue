<template lang="">
    <div>
        
    </div>
</template>
<script setup>
    import { defineProps, defineEmits } from 'vue';
    
    const props = defineProps({
        modelValue: Number
    })

    const emit = defineEmits(['update:modelValue'])

    const onInputChange = (val) => {
        emit('update:modelValue', val)
    }

    const startMicrophone = async () => {
    try {
        // Request access to the microphone
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        console.log('Microphone access granted');

        // Create an audio context
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();

        // Create a source from the microphone stream
        const source = audioContext.createMediaStreamSource(stream);

        // Create an analyser node
        const analyser = audioContext.createAnalyser();
        analyser.fftSize = 256; // Lower FFT size for quicker response
        const dataArray = new Uint8Array(analyser.frequencyBinCount);

        // Connect the source to the analyser
        source.connect(analyser);

        // Function to calculate and display the volume
        const calculateVolume = () => {
        analyser.getByteFrequencyData(dataArray);

        // Get the average of the frequency data (volume level)
        const volume = dataArray.reduce((sum, value) => sum + value, 0) / dataArray.length;
        onInputChange(volume)

        // Call the function repeatedly to update the volume
        requestAnimationFrame(calculateVolume);
        };

        // Start calculating the volume
        calculateVolume();
    } catch (error) {
        console.error('Error accessing microphone:', error);
    }
    };

    // Start listening for microphone input
    startMicrophone();
</script>
<style lang="">
    
</style>
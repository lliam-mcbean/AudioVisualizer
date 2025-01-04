<script setup>
    import { inject } from 'vue';
    const normalized = inject('normalized')
    const bars = inject('bars')

    const  selectItem = (item) => {
        console.log(normalized)
        normalized.value = false
        bars.value = false

        item.value = true
    }

</script>
<template lang="">
    <div class="h-screen absolute w-[50px] flex items-center">
        <div class="left-0 w-full text-2xl">
            <div 
                @click="selectItem(normalized)" 
                class="h-[50px] w-full cursor-pointer border border-2 border-white text-white flex justify-center items-center hover:text-yellow-500 hover:border-yellow-500"
                :class="{'text-blue-500 border-blue-500': normalized.value}"
            >
                <font-awesome-icon :icon="['far','circle']" />
            </div>
            <div 
                @click="selectItem(bars)" 
                class="h-[50px] w-full cursor-pointer border border-2 border-white text-white flex justify-center items-center hover:text-yellow-500 hover:border-yellow-500"
                :class="{'text-blue-500 border-blue-500': bars.value}"
            >
                <font-awesome-icon :icon="['far','square']" />
            </div>
        </div>
    </div>
</template>
<style lang="">
    
</style>
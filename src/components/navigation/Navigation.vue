<script setup>
    import { inject } from 'vue';

    const normalized = inject('normalized')
    const bars = inject('bars')
    const gridBars = inject('gridBars')
    const reverb = inject('reverb')
    const snake = inject('snake')
    const cubeSnake =  inject('cubeSnake')
    const fire = inject('fire')

    const  selectItem = (item) => {
        normalized.value = false
        bars.value = false
        gridBars.value = false
        reverb.value = false
        snake.value = false
        cubeSnake.value = false
        fire.value = false

        item.value = true
    }

</script>
<template lang="">
    <div class="h-screen absolute w-[50px] flex items-center z-50">
        <div class="left-0 w-full text-2xl">
            <div 
                @click="selectItem(normalized)" 
                class="h-[50px] w-full cursor-pointer border border-2 flex justify-center items-center hover:text-[#ffffc5] hover:border-[#ffffc5]"
                :class="{
                    'text-[#7bcceb] border-[#7bcceb]': normalized.value,
                    'border-white text-white' : !normalized.value
                }"
            >
                <font-awesome-icon :icon="['far','circle']" />
            </div>
            <div 
                @click="selectItem(bars)" 
                class="h-[50px] w-full cursor-pointer border border-2 flex justify-center items-center hover:text-[#ffffc5] hover:border-[#ffffc5]"
                :class="{
                    'text-[#7bcceb] border-[#7bcceb]': bars.value,
                    'border-white text-white' : !bars.value
                }"
            >
            <font-awesome-icon :icon="['fas', 'chart-simple']" />
            </div>
            <div 
                @click="selectItem(gridBars)" 
                class="h-[50px] w-full cursor-pointer border border-2 flex justify-center items-center hover:text-[#ffffc5] hover:border-[#ffffc5]"
                :class="{
                    'text-[#7bcceb] border-[#7bcceb]': gridBars.value,
                    'border-white text-white' : !gridBars.value
                }"
            >
                <font-awesome-icon :icon="['fas','cubes']" />
            </div>
            <div 
                @click="selectItem(reverb)" 
                class="h-[50px] w-full cursor-pointer border border-2 flex justify-center items-center hover:text-[#ffffc5] hover:border-[#ffffc5]"
                :class="{
                    'text-[#7bcceb] border-[#7bcceb]': reverb.value,
                    'border-white text-white' : !reverb.value
                }"
            >
                <font-awesome-icon :icon="['fas','water']" />
            </div>
            <div 
                @click="selectItem(snake)" 
                class="h-[50px] w-full cursor-pointer border border-2 flex justify-center items-center hover:text-[#ffffc5] hover:border-[#ffffc5]"
                :class="{
                    'text-[#7bcceb] border-[#7bcceb]': snake.value,
                    'border-white text-white' : !snake.value
                }"
            >
                <font-awesome-icon :icon="['fas','rod-snake']" />
            </div>
            <div 
                @click="selectItem(cubeSnake)" 
                class="h-[50px] w-full cursor-pointer border border-2 flex justify-center items-center hover:text-[#ffffc5] hover:border-[#ffffc5]"
                :class="{
                    'text-[#7bcceb] border-[#7bcceb]': cubeSnake.value,
                    'border-white text-white' : !cubeSnake.value
                }"
            >
                <font-awesome-icon :icon="['fab','codepen']" />
            </div>
            <div 
                @click="selectItem(fire)" 
                class="h-[50px] w-full cursor-pointer border border-2 flex justify-center items-center hover:text-[#ffffc5] hover:border-[#ffffc5]"
                :class="{
                    'text-[#7bcceb] border-[#7bcceb]': fire.value,
                    'border-white text-white' : !fire.value
                }"
            >
                <font-awesome-icon :icon="['fas','fire']" />
            </div>
        </div>
    </div>
</template>
<style lang="">
    
</style>
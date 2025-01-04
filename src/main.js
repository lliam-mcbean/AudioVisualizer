import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { library } from '@fortawesome/fontawesome-svg-core';
import { faCircle, faSquare } from '@fortawesome/free-regular-svg-icons';

library.add(faCircle, faSquare);

const app = createApp(App)

app.component('font-awesome-icon', FontAwesomeIcon);
app.mount('#app')
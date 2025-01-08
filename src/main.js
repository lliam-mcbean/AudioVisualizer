import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { library } from '@fortawesome/fontawesome-svg-core';
import { faCircle, faSquare } from '@fortawesome/free-regular-svg-icons';
import { faCodepen } from '@fortawesome/free-brands-svg-icons';
import { faCubes, faArrowLeft, faWater, faChartSimple, faRodSnake} from '@fortawesome/free-solid-svg-icons';

library.add(faCircle, faSquare, faCubes, faArrowLeft, faWater, faChartSimple, faRodSnake, faCodepen);

const app = createApp(App)

app.component('font-awesome-icon', FontAwesomeIcon);
app.mount('#app')
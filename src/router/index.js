import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../components/HelloWorld.vue'
import crowdfund from '../components/Crowdfund.vue'
import donation from '../components/Donation.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: Home
  },
  {
    path: '/crowdfund',
    name: 'crowdfund',
    component: crowdfund
  },
  {
    path: '/donation',
    name: 'donation',
    component: donation
    
  }
]

const router = new VueRouter({
  routes
})

export default router

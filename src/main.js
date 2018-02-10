// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import VueRouter from 'vue-router'
import app from './app'
import home from './components/home'
import membership from './components/membership'
import register from './components/register'

const routes = [
  { path: '/', component: home },
  { path: '/home', component: home },
  { path: '/membership', component: membership },
  { path: '/register', component: register },
]

const router = new VueRouter({
  routes // short for routes: routes
})

Vue.use(VueRouter)

/* eslint-disable no-new */
new Vue({
  el: '#app',
  template: '<app/>',
  components: { app },
  router: router
})


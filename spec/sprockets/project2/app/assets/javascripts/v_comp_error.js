
Vue.component('bulma-error', {
  props : ['text'],
  template : `
    <p class="help is-danger" v-if="this.text.length > 0">{{this.text}}</p>
  `
});

Vue.component('v-label', {
  props : ['field', 'text', 'error'],
  template : `
    <label class="label" :for="field">{{text}}</label>
  `
});

Vue.component('bulma-error', {
  props : ['text'],
  template : `
    <p class="help is-danger" v-if="this.text.length > 0">{{this.text}}</p>
  `
});

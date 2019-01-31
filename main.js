(function (lo, beautify, md, Vue) {
  'use strict';

  var OutputWrapper = Vue.extend({
    props: {
      componentId: String,
      source: String
    },
    template: '<component :is="componentId" :source="source"/>'
  });

  Vue.component('html-source', {
    props: ['source'],
    template: '<pre class="html-source">{{ source }}</pre>'
  });

  Vue.component('html-preview', {
    props: ['source'],
    template: '<div class="preview content"><div v-html="source"></div></div>'
  });

  /**
   * Create root Vue instance.
   */
  function createInstance () {
    return new Vue({
      el: '#app',
      data: {
        input: '',
        raw: window.location.hash === '#raw'
      },
      computed: {
        output: function () {
          var compiled = md.render(this.input);
          return beautify.html(compiled);
        },
        outputComponentId: function () {
          return this.raw ? 'html-source' : 'html-preview';
        }
      },
      methods: {
        onUpdate: lo.debounce(function (e) {
          this.input.markdown = e.target.value;
        }, 400)
      },
      components: {
        'output-wrapper': OutputWrapper
      }
    });
  }

  /**
   * Entry point
   */
  function main() {
    window.vm = createInstance();
  }

  main();
})(_, beautifier, markdownit().use(markdownitDeflist), (Vue.default ? Vue : (Vue.default = Vue)).default)
;
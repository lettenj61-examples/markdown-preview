// ports for Elm application

// These modules are loaded globally from CDN: see [index.html].
// import beautifier from 'js-beautify';
// import markdownit from 'markdown-it';
// import markdownitDeflist from 'markdown-it-deflist';

var Ports = (function() {
  /**
   * A markdown compiler.
   */
  var compiler = markdownit().use(markdownitDeflist);

  /**
   * Notify compilation result to port on Elm.
   */
  var notify = function(port, input) {
    var output = compiler.render(input);
    // port htmlSource :: (String -> msg) -> Cmd msg
    port.send(beautifier.html(output));
  };

  /**
   * Update preview element.
   */
  function refresh(showSource) {
    var preview = document.getElementById('preview');
    if (!preview) {
      return;
    }
    preview[showSource ? 'innerText' : 'innerHTML'] = preview.dataset.render;
  }

  /**
   * Initialize ports for the `app`.
   * 
   * @param {Elm.Application} app 
   */
  function install(app) {
    // port compileMarkdown :: String -> Cmd msg
    app.ports.compileMarkdown.subscribe(function(input) {
      notify(app.ports.htmlSource, input);
    });

    // port requestPreview :: () -> Cmd msg
    app.ports.requestPreview.subscribe(function(mode) {
      refresh(mode);
    });
  }

  return {
    install: install
  }
})();

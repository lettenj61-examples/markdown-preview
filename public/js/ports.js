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
   * Render compiled HTML.
   */
  function renderHtml(input) {
    var output = compiler.render(input);
    var preview = document.getElementById('preview');
    if (!preview) {
      return;
    }
    preview.dataset.render = output.trim();
  };

  /**
   * Update preview element.
   */
  function refresh() {
    var preview = document.getElementById('preview');
    var previewContent = document.querySelectorAll('.preview-content');
    if (!preview || !previewContent.length) {
      return;
    }
    for (var i = 0; i < previewContent.length; i++) {
      var elem = previewContent[i]
      if (elem.nodeName === 'PRE') {
        elem.innerText = preview.dataset.render;
      } else {
        elem.innerHTML = preview.dataset.render;
      }
    }
  }

  /**
   * Initialize ports for the `app`.
   * 
   * @param {Elm.Application} app 
   */
  function install(app) {
    // port compileMarkdown :: String -> Cmd msg
    app.ports.compileMarkdown.subscribe(function(input) {
      renderHtml(input);
    });

    // port requestPreview :: () -> Cmd msg
    app.ports.requestPreview.subscribe(function() {
      refresh();
    });
  }

  return {
    install: install
  }
})();

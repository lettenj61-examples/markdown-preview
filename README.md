# markdown-preview

Markdown preview page with Elm.

## Query options

You can add query strings to set markdown options.

* `?sanitize`: `"true" | "false"`
  * Enale or disable sanitization of markdown source. Set this to `false` will allow you to render plain HTML.


## Development

```bash
$ pnpm run make
```

Above compiles Elm source to JavaScript into `./public/js` .

Serve `./public` directory with your favorite development server and visit `index.html` to see working application.


# Four strings

The wave lives in `string.vert`. That is the file to edit.

```bash
python3 -m http.server
```

Open `/strings/`. Change `HARMONICS`, `STIFFNESS`, `DAMP`, or rewrite `modal()`. Save, refresh — shaders are fetched with the cache off, so you see the new compile immediately. Errors print on the page.

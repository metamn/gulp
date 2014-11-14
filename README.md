## Atomic components based static site generator

### Folders:

- components: the source code
- assets: all assets
- scripts: Styleguide generator (or other) scripts
- site: the generated website


### Rules:
1. Do not add files manually. Let the styleguide generator add/move/remove the files

### Usage:

1. gulp watch && compass watch
2. sg g pages/styleguide
3. sg g pages/home


### Known issues:

- gulp watch not always works when files are deleted


### How it works

- .swig files are compiled to .html
- .js files are concatenated into main.min.js
- .scss files are compiled to .css by Compass

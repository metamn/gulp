
// Atomic components based static site generator
// ---------------------------------------------
//
//
// Folders:
// - components: the source code
// - assets: source assets
// - scripts: Styleguide generator (or other) scripts
// - build: swig files compiled to html. they preserve the atomic model
// - site: the atomic model urls from _build packaged to normal website urls
//
//
// Rules:
// 1. Do not add files manually. Let the styleguide generator add/move/remove the files
//
//
// Usage:
// 1. gulp watch && compass watch
// 2. sg g pages/styleguide
// 3. sg g pages/home
//
//
// Known issues:
// - gulp watch not always works when files are deleted
//
//
// How it works
// - .swig files are compiled to .html by this script
// - .js files are concatenated into main.min.js by this script
// - .scss files are compiled to .css by Compass




// Plugins
var gulp = require('gulp'),
    del = require('del'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    browserSync = require('browser-sync'),
    runSequence = require('run-sequence'),

    swig = require('gulp-swig'),
    data = require('gulp-data'),
    fm = require('front-matter'),

    minifycss = require('gulp-minify-css'),
    uglify = require('gulp-uglify');


// Folder structure
var paths = {
  components: 'components',
  swig: 'components/**/*.swig',
  css: 'components/pages/*.css',
  js: 'components/**/*.js',
  styles: 'site/assets/styles',
  scripts: 'site/assets/scripts',
  pages: 'components/pages/*.html',
  styleguide: 'components/pages/styleguide/**/*.html',
  site: 'site',
  home: 'site/home',
};


// Swig
// - compiles a .swig file with YAML front matter
// - renames to .html and moves to build/
gulp.task('swig', function() {
  return gulp.src(paths.swig)
    .pipe(data(function(file) {
      var content = fm(String(file.contents));
      file.contents = new Buffer(content.body);
      return content.attributes;
    }))
    .pipe(swig({
      defaults: {
        cache: false
      }
    }))
    .pipe(rename({ extname: '.html' }))
    .pipe(gulp.dest(paths.components));
});


// Styles
// - moves all .css friles from components/ to build/assets/styles
// - .css is created by Compass not Gulp
gulp.task('styles', function() {
  return gulp.src(paths.css)
    .pipe(rename({ suffix: '.min' }))
    .pipe(minifycss())
    .pipe(gulp.dest(paths.styles));
});


// Scripts
// - collects all .js files into main.js, then minify into main.min.js, then move to build/assets/scripts
gulp.task('scripts', function() {
  return gulp.src(paths.js)
    .pipe(concat('main.js'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(uglify())
    .pipe(gulp.dest(paths.scripts));
});


// Pages
// - compacting files from build/pages into site/
// - ex: build/pages/home.html => site/home/index.html
gulp.task('pages', function() {
  return gulp.src(paths.pages)
    .pipe(rename(function(path) {
      path.dirname = path.basename;
      path.basename = 'index';
    }))
    .pipe(gulp.dest(paths.site))
  ;
});


// Styleguide
// - compacting files from build/pages/styleguide into site/
// - ex: build/pages/styleguide/pages/home.html => site/styleguide/pages/home/index.html
gulp.task('styleguide', function() {
  return gulp.src(paths.styleguide)
    .pipe(rename(function(path) {
      path.dirname = '/styleguide/' + path.dirname + '/' + path.basename + '/';
      path.basename = 'index';
    }))
    .pipe(gulp.dest(paths.site))
  ;
});


// Home
// - making a homepage from an existing page
// ex: site/home/index.html => index.html
gulp.task('home', function(cb) {
  gulp.src(paths.home + '/index.html')
    .pipe(rename('index.html'))
    .pipe(gulp.dest(paths.site))
  del([paths.home]);
  cb();
});



// Clean site/
gulp.task('clean', function(cb) {
  del([paths.site + '/**/*']);
  cb();
});




// The default task
gulp.task('default', function(cb) {
  runSequence(
    'clean',
    'swig',
    'styles',
    'scripts',
    'pages',
    'styleguide',
    'home',
    cb
  );
});


// Start server
gulp.task('server', function(cb) {
  browserSync({
    server: {
      baseDir: paths.site
    }
  });

  cb();
});


// Watch
gulp.task('watch', ['server'], function(cb) {
  gulp.watch('components/**/*', ['default']);

  cb();
});

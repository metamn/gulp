// Plugins
var gulp = require('gulp'),
    del = require('del'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    browserSync = require('browser-sync'),

    swig = require('gulp-swig'),
    data = require('gulp-data'),
    fm = require('front-matter'),

    minifycss = require('gulp-minify-css'),
    uglify = require('gulp-uglify');


// Folder structure
var paths = {
  swig: 'components/pages/*.swig',
  css: 'components/pages/*.css',
  js: 'components/**/*.js',
  build: 'build',
  build_styles: 'build/assets/styles',
  build_scripts: 'build/assets/scripts',
  build_pages: 'build/pages/*.html',
  build_styleguide: 'build/pages/styleguide/**/*.html',
  site: 'site',
  home: 'site/home/index.html',
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
    .pipe(gulp.dest(paths.build))
    .pipe(browserSync.reload({stream:true}));
});


// Styles
// - moves all .css friles from components/ to build/assets/styles
// - .css is created by Compass not Gulp
gulp.task('styles', function() {
  return gulp.src(paths.css)
    .pipe(rename({ suffix: '.min' }))
    .pipe(minifycss())
    .pipe(gulp.dest(paths.build_styles))
    .pipe(browserSync.reload({stream:true}));
});


// Scripts
// - collects all .js files into main.js, then minify into main.min.js, then move to build/assets/scripts
gulp.task('scripts', function() {
  return gulp.src(paths.js)
    .pipe(concat('main.js'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(uglify())
    .pipe(gulp.dest(paths.build_scripts))
    .pipe(browserSync.reload({stream:true}));
});


// Clean build/
gulp.task('clean-build', function() {
  del([paths.build + '/**/*'])
});


// Clean site/
gulp.task('clean-site', function() {
  del([paths.site + '/**/*'])
});


// Default task
// - this task builds the components/ into /build
gulp.task('default', ['clean-build'], function() {
  gulp.start('swig', 'styles', 'scripts');
});


// Pages
// - compacting files from build/pages into site/
// - ex: build/pages/home.html => site/home/index.html
gulp.task('pages', function() {
  return gulp.src(paths.build_pages)
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
  return gulp.src(paths.build_styleguide)
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
gulp.task('home', function() {
  return gulp.src(paths.home)
    .pipe(rename('index.html'))
    .pipe(gulp.dest(paths.site))
});


// Site
// - compacting files from build/ into /site
gulp.task('site', ['clean-site', 'pages', 'styleguide'], function() {
  gulp.start('home');
  del(['site/home']);
});


// Start the server
gulp.task('start-server', function() {
  browserSync({
    server: {
      baseDir: paths.build + '/pages/'
    }
  });
});



// Watch
// - different file type changes are watched separately
gulp.task('watch', ['default', 'start-server'], function () {
  gulp.watch(paths.swig, ['swig'])
    .on('change', function(event) {
      // deleted files are not always catched ... it's like a bug
      console.log('File ' + event.path + ' was ' + event.type);
    });

  gulp.watch(paths.css, ['styles']);
  gulp.watch(paths.js, ['scripts']);
});

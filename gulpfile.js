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
  swig: 'components/**/*.swig',
  css: 'components/pages/*.css',
  js: 'components/**/*.js',
  build: 'build',
  build_styles: 'build/assets/styles',
  build_scripts: 'build/assets/scripts',
  build_pages: 'build/pages/*.html',
  site: 'site',
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


// Clean
gulp.task('clean', function(cb) {
  del([paths.build + '/**/*'], cb)
});


// Default task
// - this task builds the site into /build
gulp.task('default', ['clean'], function() {
  gulp.start('swig', 'styles', 'scripts');
});


// Site
// - compacting files from build/ into site/
gulp.task('site', function() {
  del([paths.site + '/**/*']);

  return gulp.src(paths.build_pages)
    .pipe(rename(function(path) {
      path.dirname = path.basename;
      path.basename = 'index';
    }))
    .pipe(gulp.dest(paths.site))
  ;
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

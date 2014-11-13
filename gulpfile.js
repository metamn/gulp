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


// Swig
// - compiles a .swig file with YAML front matter
// - renames to .html and moves to build/
gulp.task('swig', function() {
  return gulp.src('components/**/*.swig')
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
    .pipe(gulp.dest('build'))
    .pipe(browserSync.reload({stream:true}));
});


// Styles
// - moves all .css friles from components/ to build/assets/styles
// - .css is created by Compass not Gulp
gulp.task('styles', function() {
  return gulp.src('components/*.css')
    .pipe(rename({ suffix: '.min' }))
    .pipe(minifycss())
    .pipe(gulp.dest('build/assets/styles'))
    .pipe(browserSync.reload({stream:true}));
});


// Scripts
// - collects all .js files into main.js, then minify into main.min.js, then move to build/assets/scripts
gulp.task('scripts', function() {
  return gulp.src('components/**/*.js')
    .pipe(concat('main.js'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(uglify())
    .pipe(gulp.dest('build/assets/scripts'))
    .pipe(browserSync.reload({stream:true}));
});


// Clean
gulp.task('clean', function(cb) {
  del(['build/**/*'], cb)
});


// Default task
gulp.task('default', ['clean'], function() {
  gulp.start('swig', 'styles', 'scripts');
});



// Start the server
gulp.task('start-server', function() {
  browserSync({
    server: {
      baseDir: "build/pages/"
    }
  });
});



// Watch
// - different file type changes are watched separately
gulp.task('watch', ['default', 'start-server'], function () {
  gulp.watch('components/**/*.swig', ['swig'])
    .on('change', function(event) {
      console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
    });

  gulp.watch('components/**/*.scss', ['styles']);
  gulp.watch('components/**/*.js', ['scripts']);
});

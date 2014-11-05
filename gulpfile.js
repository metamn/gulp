var gulp = require('gulp'),
    minifycss = require('gulp-minify-css'),
    uglify = require('gulp-uglify'),
    jshint = require('gulp-jshint'),
    imagemin = require('gulp-imagemin'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    notify = require('gulp-notify'),
    cache = require('gulp-cache'),
    browserSync = require('browser-sync'),
	reload = browserSync.reload,
    del = require('del');


// Styles
gulp.task('styles', function() {
  return gulp.src('components/*.css')
    .pipe(rename({ suffix: '.min' }))
    .pipe(minifycss())
    .pipe(gulp.dest('build/assets/styles'))
    .pipe(notify({ message: 'Styles task complete' }));
});


// Scripts
gulp.task('scripts', function() {
  return gulp.src('components/**/*.js')
    .pipe(jshint('.jshintrc'))
    .pipe(jshint.reporter('default'))
    .pipe(concat('main.js'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(uglify())
    .pipe(gulp.dest('build/assets/scripts'))
    .pipe(notify({ message: 'Scripts task complete' }));
});



// Clean
gulp.task('clean', function(cb) {
    del(['build/**/*'], cb)
});


// Default task
gulp.task('default', ['clean'], function() {
    gulp.start('styles', 'scripts');
});


// Watch
gulp.task('watch', function() {
  
  // Watch .scss files
  gulp.watch('components/.css', ['styles']);
 
  // Watch .js files
  gulp.watch('components/**/*.js', ['scripts']);
 
  browserSync({
    notify: false,
    server: {
      baseDir: ['build']
    }
  });
 
  // Watch any files in dist/, reload on change
  gulp.watch(['dist/**']).on('change', reload);
 
});
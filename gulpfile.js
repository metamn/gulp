var gulp = require('gulp'),
    notify = require('gulp-notify'),
    del = require('del'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),

    browserSync = require('browser-sync'),
	reload = browserSync.reload,

    swig = require('gulp-swig'),
    data = require('gulp-data'),
    fm = require('front-matter'),

    minifycss = require('gulp-minify-css'),
    uglify = require('gulp-uglify');



function errorHandler(error) {
  notify('Error: ' + error.message);
}


// Swig
// - compiles a .swig file with YAML front matter
// - renames to .html in the same folder
gulp.task('swig', function() {
  return gulp.src('components/**/*.swig')
    .pipe(data(function(file) {
      var content = fm(String(file.contents));
      file.contents = new Buffer(content.body);
      return content.attributes;
    }))
    .pipe(swig())
    .pipe(rename({ extname: '.html' }))
    .pipe(gulp.dest('components'))
    .pipe(notify("Swig OK"));
});


// HTML
// - moves all .html files from components/pages to build/
gulp.task('html', function() {
  return gulp.src('components/pages/*.html')
    .pipe(gulp.dest('build'))
    .pipe(notify("HTML OK"));
});


// Styles
gulp.task('styles', function() {
  return gulp.src('components/screen.css')
    .pipe(rename({ suffix: '.min' }))
    .pipe(minifycss())
    .pipe(gulp.dest('build/assets/styles'))
    .pipe(notify("Styles OK"));
});


// Scripts
gulp.task('scripts', function() {
  return gulp.src('components/**/*.js')
    .pipe(concat('main.js'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(uglify())
    .pipe(gulp.dest('build/assets/scripts'))
    .pipe(notify("Scripts OK"));
});



// Clean
gulp.task('clean', function(cb) {
  del(['build/**/*'], cb)
});


// Default task
gulp.task('default', ['clean'], function() {
  gulp.start('swig', 'html', 'styles', 'scripts');
});


// Watch
gulp.task('watch', function() {

  // Watch swig files
  gulp.watch('components/**/.swig', ['swig']);

  // Move compiled html
  gulp.watch('components/pages/*.html', ['html']);

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

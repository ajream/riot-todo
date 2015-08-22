var gulp = require('gulp');
var riot = require('gulp-riot');
var concat = require('gulp-concat');
var install = require("gulp-install");
var webserver = require('gulp-webserver');

var server = {
  host: 'localhost',
  port: '8001'
}

// 将 tag 文件合并
gulp.task('riot', function () {
  return gulp.src(['./tags/*.tag'])
    .pipe(riot())
    .pipe(concat('main.js'))
    .pipe(gulp.dest('./tags'))
});

// 安装前端依赖
gulp.task('npm install', function() {
  return gulp.src(['./package.json'])
    .pipe(install());
});

gulp.task('webserver', function() {
  gulp.src('.')
    .pipe(webserver({
      host: server.host,
      port: server.port,
      livereload: false,
      directoryListing: true,
      open: 'index.html'
    }));
});

gulp.task('default', function () {
  gulp.run('riot', 'npm install', 'webserver');
  // 监听文件变化
  gulp.watch('./tags/*.tag', function(){
   gulp.run('riot');
  });
});
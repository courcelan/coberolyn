#
# LOAD DEPENDENCIES
#
gulp = require 'gulp'
utils = require 'gulp-util'
colors = utils.colors
plugins = do require 'gulp-load-plugins'


connect = require 'connect'
open = require 'open'
http = require 'http'
fs = require 'fs'
yaml = require 'js-yaml'

#
# LOAD YAML CONFIGS
#
yamlLoad = (file) -> yaml.safeLoad fs.readFileSync file, 'utf8'

config = yamlLoad './config.yaml'
src = config.path.src
build = config.path.build

#
# GET ENVIRONMENT
#
config.minify = utils.env.minify

#
# DEFAULT
#

gulp.task 'default', 
  [
    'serve'
  ], ->
    console.log colors.yellow 'Running gulp development server'



#
# JADE
#

gulp.task 'jade', ->
  
  site = yamlLoad './site.yaml'
  
  options =
    pretty: true
    basedir: "./#{src.base}/_templates/"
    locals: site

  if config.static
  then options.locals.static = config.static
  else options.locals.static = ""

  gulp
    .src(
      [
        "**/*.jade"
        "!**/_*.jade"
        "!_*/*.jade"
      ],
      cwd: "./#{src.html}"
    )
    .pipe(plugins.jade( options ))
    .pipe(
      plugins.if !config.minify, 
        plugins.embedlr()
    )
    .pipe(
      gulp.dest "#{build.base}/"
    )
    .pipe( 
      plugins.if !config.minify, 
        plugins.livereload() 
    )



#
# STYLUS
#

gulp.task 'stylus', ->
  options =
    compress: true
    log: true
    showFiles: true

  gulp
    .src(
      [
        "*.styl"
        "!_*.styl"
      ],
      cwd: "./#{src.base}/#{src.css}"
    )
    .pipe( plugins.stylus(options) )
    .pipe( 
      plugins.if config.minify, 
        plugins.combineMediaQueries(options) 
    )
    .pipe( 
      plugins.if config.minify,
        plugins.size(options) 
    )
    .pipe( 
      plugins.if config.minify,
        plugins.minifyCss() 
    )
    .pipe( plugins.size(options) )
    .pipe(
      gulp.dest "#{build.base}/#{build.static}/#{build.css}/"
    )
    .pipe( 
      plugins.if !config.minify,
        plugins.livereload() 
    )


#
# ASSETS
#

gulp.task 'assets', ->

  gulp
    .src(
      [
        "**/*.*"
      ]
      cwd: "./#{src.base}/#{src.assets}"
    )
    .pipe( plugins.imagemin() )
    .pipe(
      gulp.dest "#{build.base}/#{build.static}/#{build.assets}/"
    )


#
# CLOUDVENT
#

gulp.task 'cloudvent', ->
  deploy = config.deploy
  
  if deploy.dropbox_user and deploy.cloudvent
    gulp
      .src( 
        [
          "**/*"
        ],
        cwd: build.base
      )
      .pipe(
        gulp.dest "/Users/#{ deploy.dropbox_user }/Dropbox/Apps/Cloud\ Cannon/#{ deploy.cloudvent }"
      )
      
    console.log colors.gray 'Site deployed to cloudvent'

#
# BOWER
#

gulp.task 'bower', ->
  plugins.bower().pipe( gulp.dest "#{ src.base }/#{ src.vendor }/" )



#
# LOCAL STATIC SERVER
#

gulp.task 'serve', ['watch'], (callback) ->
    
  app = connect()
    .use( connect.static(build.base) )
  
  devServer = http
    .createServer( app )
    .listen( config.dev.port )

  devServer.on 'error', (error) ->
    console.log colors.underline( colors.red('ERROR')+' Unable to start server!' )
    callback error

  devServer.on 'listening', ->
    url = "http://localhost:#{config.dev.port}"
    console.log ''
    console.log "Started dev server at: " + colors.green( url )

    if utils.env.open
      console.log colors.yellow "Opening dev server at #{ url }"
      open url
    else
      console.log colors.gray '(Run with --open to automatically open URL on startup)'
    
    console.log ''
    callback()

#
# WATCH
#

gulp.task 'watch', 
  [
    'jade'
    'stylus'
  ],
  ->
    lr = plugins.livereload()   

    gulp
      .watch(
        "./#{ src.base }/**/*"
        [
          'jade'
          'stylus'
        ]
      )
module.exports = (grunt) ->
  path = require('path')

#    .aMMMb  .aMMMb  dMMMMb  dMMMMMP dMP .aMMMMP
#   dMP"VMP dMP"dMP dMP dMP dMP     amr dMP"
#  dMP     dMP dMP dMP dMP dMMMP   dMP dMP MMP"
# dMP.aMP dMP.aMP dMP dMP dMP     dMP dMP.dMP
# VMMMP"  VMMMP" dMP dMP dMP     dMP  VMMMP"

  require('load-grunt-config') grunt,
    configPath: path.join(process.cwd(), 'grunt_tasks/options')
    config:
      cloudvent: 'coberolyn.is'
      src:
        base: '_dev_src'
        html: '<%= src.base %>'
        css: '_css'
        js: '_js'
        assets: '_res'
        vendor: '_bower_components'

      build:
        base: 'public/'
        static: 'static'
        css: 'css'
        js: 'js'
        assets: 'res'
        vendor: 'vendor'

      bower_packages:
        angular: ''
        'angular-sanitize': ''
        'angular-mocks': ''
        modernizr: ''

      locals: grunt.file.readYAML 'site.yaml'

#     dMMMMMP dMP dMP dMMMMMP dMMMMb dMMMMMMP .dMMMb
#    dMP     dMP dMP dMP     dMP dMP   dMP   dMP" VP
#   dMMMP   dMP dMP dMMMP   dMP dMP   dMP    VMMMb
#  dMP      YMvAP" dMP     dMP dMP   dMP   dP .dMP
# dMMMMMP    VP"  dMMMMMP dMP dMP   dMP    VMMMP"

  grunt.event.on 'watch', (action, filepath, target) ->
    grunt.log.writeln target + ': ' + filepath + ' has ' + action


#  dMMMMMMP .aMMMb  .dMMMb  dMP dMP .dMMMb
#    dMP   dMP"dMP dMP" VP dMP.dMP dMP" VP
#   dMP   dMMMMMP  VMMMb  dMMMMK"  VMMMb
#  dMP   dMP dMP dP .dMP dMP"AMF dP .dMP
# dMP   dMP dMP  VMMMP" dMP dMP  VMMMP"

  grunt.loadTasks("grunt_tasks")


  # the default task can be run just by typing "grunt" on the command line
  grunt.registerTask 'default',
    'run default tasklist, currently set to dev tasks'
    [
      'dev'
    ]

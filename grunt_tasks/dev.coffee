module.exports = (grunt) ->

  grunt.registerTask 'dev',
    'run general tasks for development and browser testing'
    [
      'yaml:dev'
      'json:models'
      'karma:unit_once'
      'jade:dev'
      'stylus:dev'
      'coffee:dev'
      'concat:js'
      'copy:vendor'
      'copy:assets'
    ]

  grunt.registerTask 'serve',
    'runs development tasks, starts and opens local server, runs watch'
    [
      'dev'
      'connect:dev'
      'open:dev'
      'watch'
    ]

  grunt.registerTask 'stylus_dev',
    'runs just stylus tasks for development'
    [
      'stylus:dev'
      'copy:assets'
    ]


  grunt.registerTask 'coffee_dev',
    'runs just coffeescript tasks for development'
    [
      'coffee:dev'
      'concat:js'
      'copy:assets'
      'clean:deploy'
      # 'karma:e2e' removing until we can go to grunt-protractor
    ]
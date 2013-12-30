module.exports = (grunt) ->

  grunt.registerTask 'test', 
    'lints coffeescript and unit tests'
    [
      'coffeelint'
      'karma:unit_once'
    ]
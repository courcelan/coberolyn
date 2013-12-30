module.exports = (grunt) ->

  grunt.registerTask 'init',
    'initialize general website project'
    [
      'shell:vefa_init'
    ]
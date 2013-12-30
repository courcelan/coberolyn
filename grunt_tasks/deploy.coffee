module.exports = (grunt) ->


  grunt.registerTask 'deploy_main_tasks',
    'subtask to share among deploy tasks'
    [
      #'jade:deploy'
      'stylus:deploy'
      'coffee:deploy'
      'concat:js'      
      'uglify:deploy'
      'copy:vendor'
      'copy:assets'
      'clean:deploy'
    ]

  grunt.registerTask 'deploy_pre_tasks',
    'subtask to share among deploy tasks'
    [
      'yaml:dev'
      'json:models'
    ]



  grunt.registerTask 'deploy',
    'run tasks for deployment'
    [
      'deploy_pre_tasks'
      'karma:unit_once' 
      'deploy_main_tasks'
    ]


  grunt.registerTask 'deploy-patch',
    'run tasks for deployment'
    [
      'deploy_pre_tasks'
      'karma:unit_once'
      'bump-only:patch'
      'deploy_main_tasks'
      'bump-commit'
    ]


  grunt.registerTask 'deploy-minor',
    'run tasks for deployment'
    [
      'deploy_pre_tasks'
      'karma:unit_once'
      'bump-only:minor'
      'deploy_main_tasks'
      'bump-commit'
    ]

  
  grunt.registerTask 'deploy-major',
    'run tasks for deployment'
    [
      'deploy_pre_tasks'
      'karma:unit_once'
      'bump-only:major'
      'deploy_main_tasks'
      'bump-commit'
    ]
  
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
      pkg: grunt.file.readJSON 'package.json'
      env: process.env
      banner_info: '''
        Project: <%= pkg.project %>
        Site: <%= pkg.site %>
        Developer: <%= pkg.author %>
        Version: <%= pkg.version %>, <%= grunt.template.today("dd-mm-yyyy") %>
      '''    

      src:
        base: '_dev_src/'
        html: '<%= src.base %>templates/'
        css: '<%= src.base %>css/'
        js: '<%= src.base %>js/'
        assets: '<%= src.base %>res/'
        vendor: '<%= src.base %>bower_components/'

      build: 
        base: 'public/'
        html: '<%= build.base %>'
        css: '<%= build.base %>css/'
        js: '<%= build.base %>js/'
        assets: '<%= build.base %>res/'
        vendor: '<%= build.base %>vendor/'

      bower_packages:
        angular: '1.2'
        'angular-sanitize': ''
        'angular-mocks': ''
        modernizr: ''

      jade_data:
        # SITE CONTENT CENTRIC
        client:
          name: "Coberolyn"
          site: "Coberolyn.is"
          url: "http://coberolyn.is"
          adr:
            street1: ""
            street2: ""
            city: ""
            state: ""
            zip: ""
          tel:
            type: ""
            number: ""
        author:
          name: "Cobey Poter"
          url: "http://courcelan.com"
        copyright: 2013
        canonical: false
        description: false
        favicon: false
        appleicon: false

        # JS CENTRIC
        jQuery: false
        sitekey: false
        typekit: "tyz6mhj"
        angular: false

        # CSS CENTRIC
        supportIE7: false
        supportIE8: false
        supportIE9: false

        # SERVER CENTRIC
        debug: true
        static: "/" #can change this to django tag for deploy

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


# roots v2.0.2

# Files in this list will not be compiled - minimatch supported
ignore_files: ['_*', 'readme*', '.gitignore', '.DS_Store']

# when compiling for Django, add 'templates' to ignore_folders
ignore_folders: ['.git', '_lib'] # , 'templates'

folder_config:
  assets: 'assets' # all front-end dev files should go here
  views: 'templates' # all template/layout files should go here

# set to 'static' for use with Django
# otherwise, keep to traditional 'public' or 'dev_static' is helpful too
output_folder: 'public'


# Layout file config
# `default` applies to all views. Override for specific
# views as seen below.
layouts:
  default: '_roots_loader.jade'
  # 'special_view.jade': 'special_layout.jade'

# Locals will be made available on every page. They can be
# variables or (coffeescript) functions.
locals:
  #### SITE CONTENT CENTRIC
  title: "Coberolyn.is"
  author: "Cobey Potter"
  domain: "coberolyn.is"
  # canonical: ""w
  # description: ""
  # favicon: ""
  # appleicon: ""

  routes: [  ]

  #### JS CENTRIC
  typekit: 'tyz6mhj'
  # angular: ''
  # jQuery: ''
  sitekey: 'UA-44315316-1'

  #### CSS CENTRIC

  # supportIE7: ''
  # supportIE8: true
  # supportIE9: true

  #### SERVER CENTRIC
  # STATIC_URL: 'http://wellfire.github.io/cso-imfirst-prototyping/'
  STATIC_URL: '/static/'

  #### FUNCTIONS
  title_with_markup: ->
    ''

  sort_on_group: (arr, sort, sort_on) ->
    new_arr = (item for item in arr when item[sort] is sort_on)

  get_nav_group: (arr, sort_on) ->
    new_arr = (item for item in arr when item['group'] is sort_on)

  url: (arr, named_item) ->
    view = item.view for item in arr when item.name is named_item

# Precompiled template path, see http://roots.cx/docs/#precompile
# templates: 'views/templates'

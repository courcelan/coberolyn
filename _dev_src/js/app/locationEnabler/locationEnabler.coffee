# Location Enabler module
# helps create HMTL5 style history/location changes
# this is built as a separate module because it hijacks links
#
# TODO: change config to a provider
# TODO: change Filter controller to a factory

angular.module('app.locationEnabler', [])

.config([
  '$locationProvider'
  ($locationProvider) ->
    # configure html5 to get links working
    # If you don't, URLs will be base.com/#/home rather than base.com/home
    $locationProvider.html5Mode true
])

# possibly make into a factory/service method?
.controller 'FilterController',
  [
    '$scope'
    '$location'
    ($scope, $location) ->

      $scope.getLocation = (checker) ->
        if $location.path() == checker
          true
        else
          false
  ]
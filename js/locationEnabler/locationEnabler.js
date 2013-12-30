angular.module('app.locationEnabler', []).config([
  '$locationProvider', function($locationProvider) {
    return $locationProvider.html5Mode(true);
  }
]).controller('FilterController', [
  '$scope', '$location', function($scope, $location) {
    return $scope.getLocation = function(checker) {
      if ($location.path() === checker) {
        return true;
      } else {
        return false;
      }
    };
  }
]);

angular.module('vefa.details', []).run(function($templateCache) {
  $templateCache.put('details.html', '<div>\n  <div class="panel" ng-show="isOpen">\n    <div ng-transclude></div>\n    <details-closer></details-closer>\n  </div>\n</div>');
  return $templateCache.put('details-closer.html', '<button class="ctrl--close"\n  type="button"\n  ng-click="toggle()"\n  ng-if="closeCtrl">\n  <i class="i--close"></i>\n  <span>Close</span>\n</button>');
}).directive('detailsGroup', function() {
  return {
    restrict: 'EAC',
    scope: {},
    controller: [
      '$scope', '$element', function($scope, $element) {
        var group_members;
        group_members = [];
        this.gotOpened = function(selected) {
          return angular.forEach(group_members, function(member) {
            if (selected !== member) {
              return member.isOpen = false;
            }
          });
        };
        this.addDetails = function(el) {
          return group_members.push(el);
        };
        this.closeAll = function() {
          return angular.forEach(group_members, function(member) {
            return member.isOpen = false;
          });
        };
      }
    ],
    link: function(scope, element, attrs, controller) {
      return scope.name = "details-group";
    }
  };
}).directive('details', function() {
  return {
    restrict: 'EC',
    require: '^?detailsGroup',
    transclude: true,
    replace: true,
    scope: {
      isOpen: '@open',
      closeCtrl: '@'
    },
    templateUrl: 'details.html',
    controller: [
      '$scope', '$element', '$attrs', function($scope, $element, $attrs) {
        $scope.name = "details";
        $scope.toggle = function() {
          return $scope.isOpen = !$scope.isOpen;
        };
        $scope.$on("closeUpdate", function(event) {
          return $scope.toggle();
        });
      }
    ],
    link: function(scope, element, attrs, controller) {
      var ngElem, summary;
      ngElem = angular.element(element);
      summary = ngElem.find('summary');
      ngElem.prepend(summary);
      summary.bind('click', function() {
        return scope.$apply(function() {
          return scope.toggle();
        });
      });
      if (controller != null) {
        controller.addDetails(scope);
      }
      return scope.$watch('isOpen', function() {
        if (scope.isOpen) {
          ngElem.attr("open", true);
          if (controller != null) {
            return controller.gotOpened(scope);
          }
        } else {
          return ngElem.removeAttr("open");
        }
      });
    }
  };
}).directive("detailsCloser", function() {
  return {
    restrict: 'E',
    replace: true,
    templateUrl: 'details-closer.html'
  };
});

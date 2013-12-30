angular.module('vefa.tabs', []).directive('tabset', function() {
  return {
    restrict: 'EAC',
    transclude: true,
    replace: true,
    scope: {},
    template: '<div>\n  <a class="tab--ctrl"\n    ng-class="{active:tab.active}"\n    ng-repeat="tab in tabs"\n    ng-click="select(tab)">\n    {{ tab.title }}\n  </a>\n  <div ng-transclude="ng-transclude"></div>\n</div>',
    controller: [
      '$scope', '$element', function($scope, $element) {
        var tabs;
        tabs = $scope.tabs = [];
        this.addTab = function(tab) {
          tabs.push(tab);
          if (tabs.length === 1 || tab.active) {
            return $scope.select(tab);
          }
        };
        $scope.select = function(tab) {
          angular.forEach(tabs, function(tab) {
            return tab.active = false;
          });
          return tab.active = true;
        };
      }
    ]
  };
}).directive('tab', function() {
  return {
    restrict: 'EAC',
    require: '^tabset',
    replace: true,
    transclude: true,
    scope: {
      title: '@'
    },
    template: '<section ng-class="{active: active}" ng-transclude></section>',
    link: function(scope, element, attrs, controller) {
      return controller.addTab(scope);
    }
  };
});

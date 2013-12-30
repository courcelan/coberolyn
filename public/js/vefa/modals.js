angular.module('vefa.modals', []).directive('vefaLightbox', function() {
  return {
    restrict: 'AC',
    replace: true,
    transclude: true,
    scope: {},
    template: "<div>\n  <div ng-transclude ng-click=\"toggle()\"></div>\n  <div class=\"modal\" ng-hide=\"!isOpen\">\n    <div class=\"modal--lightbox\">\n      <img ng-src=\"{{ src }}\"/>\n      <button class=\"ctrl--close\" ng-click=\"toggle()\">\n        <i class=\"i--close\"></i>\n        <span>Close</span>\n      </button>\n    </div>\n  </div>\n</div>",
    link: function(scope, element, attrs) {
      if (scope.isOpen == null) {
        scope.isOpen = false;
      }
      scope.toggle = function() {
        return scope.isOpen = !scope.isOpen;
      };
      return scope.$watch('isOpen', function() {
        if (scope.isOpen) {
          return scope.src != null ? scope.src : scope.src = attrs.href;
        }
      });
    }
  };
});

angular.module('vefa.ajaxinterceptor', []).controller('AjaxInterceptor', [
  '$scope', '$http', '$sce', function($scope, $http, $sce) {
    this.addMember = function(elm) {
      return group_members.push(elm);
    };
    this.assignMembers = function() {
      return group_members;
    };
    return this.bindHtml = function(html) {
      return $sce.trustAsHtml(html);
    };
  }
]).directive('interceptLoadMore', [
  '$http', '$sce', function($http, $sce) {
    return {
      restrict: 'EAC',
      replace: true,
      controller: 'AjaxInterceptor',
      scope: {
        loadMoreFrom: '@',
        pages: '@'
      },
      template: "<div>\n  <div ng-bind-html=\"results\"></div>\n  <menu type=\"toolbar\" class=\"actionbar\">\n    <button type=\"button\"\n      class=\"actionbar--item btn--gen\"\n      ng-click=\"loadMore($event)\"\n      ng-disabled=\"isDisabled()\"\n      ng-class=\"{'is-processing': inProcess}\">\n	<i class=\"i--add\" ng-hide=\"isUnavailable\"></i>\n	<span>{{ text }}</span>\n    </button>\n  </menu>\n</div>",
      link: function(scope, elm, attrs, controller) {
        scope.text = "Load More";
        scope.results = '';
        scope.current_page = 1;
        scope.inProcess = false;
        scope.isUnavailable = false;
        scope.isDisabled = function() {
          return scope.inProcess || scope.isUnavailable;
        };
        this.completeLoad = function() {
          if (scope.current_page === parseInt(scope.pages)) {
            scope.isUnavailable = true;
            return scope.text = "Loading Complete";
          }
        };
        return scope.loadMore = function($event) {
          $event.preventDefault();
          if (scope.current_page < scope.pages) {
            scope.inProcess = true;
            scope.current_page++;
          }
          return $http.get(scope.loadMoreFrom + "?page=" + scope.current_page).success(function(data) {
            scope.results = controller.bindHtml(scope.results + data);
            scope.inProcess = false;
            return this.completeLoad();
          }).error(function() {
            scope.isUnavailable = true;
            scope.inProcess = false;
            return this.completeLoad();
          });
        };
      }
    };
  }
]).directive('paginatedHook', function() {
  return {
    link: function($scope, $elm, $attrs) {
      return $scope.show = true;
    }
  };
});

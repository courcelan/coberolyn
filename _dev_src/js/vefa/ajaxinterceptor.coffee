angular.module('vefa.ajaxinterceptor', [])

# Add chosen members to catalog and intercept various
# pHTML link calls and submissions to use ajax
.controller 'AjaxInterceptor',
  [
    '$scope'
    '$http'
    '$sce'
    ($scope, $http, $sce) ->
      this.addMember = (elm) ->
        group_members.push elm

      this.assignMembers = ->
        group_members

      this.bindHtml = (html) ->
        $sce.trustAsHtml html
  ]

.directive 'interceptLoadMore',
  [
    '$http'
    '$sce'
    ($http, $sce) ->
      restrict: 'EAC'
      replace: true
      controller: 'AjaxInterceptor'
      scope:
        loadMoreFrom: '@'
        pages: '@'
      template:
        """
        <div>
          <div ng-bind-html="results"></div>
          <menu type="toolbar" class="actionbar">
            <button type="button"
              class="actionbar--item btn--gen"
              ng-click="loadMore($event)"
              ng-disabled="isDisabled()"
              ng-class="{'is-processing': inProcess}">
        	<i class="i--add" ng-hide="isUnavailable"></i>
        	<span>{{ text }}</span>
            </button>
          </menu>
        </div>
        """
      link: (scope, elm, attrs, controller) ->
        scope.text = "Load More"
        scope.results = ''
        scope.current_page = 1
        scope.inProcess = false
        scope.isUnavailable = false

        scope.isDisabled = ->
          return (scope.inProcess or scope.isUnavailable)

        this.completeLoad = ->
          if scope.current_page is parseInt scope.pages
            scope.isUnavailable = true
            scope.text = "Loading Complete"

        scope.loadMore = ($event) ->
          do $event.preventDefault

          if scope.current_page < scope.pages
            scope.inProcess = true
            scope.current_page++

          $http.get( scope.loadMoreFrom + "?page=" + scope.current_page )
            .success (data) ->
              scope.results = controller.bindHtml( scope.results + data )
              scope.inProcess = false
              do this.completeLoad
            .error ->
              scope.isUnavailable = true
              scope.inProcess = false
              do this.completeLoad

  ]


.directive 'paginatedHook', ->
  link: ($scope, $elm, $attrs) ->
    $scope.show = true
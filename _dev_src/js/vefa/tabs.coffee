angular.module('vefa.tabs', [])

.directive 'tabset', ->
  restrict: 'EAC'
  transclude: true
  replace: true
  scope: {}
  template:
    '''
      <div>
        <a class="tab--ctrl"
          ng-class="{active:tab.active}"
          ng-repeat="tab in tabs"
          ng-click="select(tab)">
          {{ tab.title }}
        </a>
        <div ng-transclude="ng-transclude"></div>
      </div>
    '''

  controller: [
    '$scope'
    '$element'
    ($scope, $element) ->
      tabs = $scope.tabs = []

      @addTab = (tab) ->
        tabs.push tab
        if tabs.length is 1 or tab.active
          $scope.select tab

      
      $scope.select = ( tab ) ->
        angular.forEach tabs, ( tab ) ->
          tab.active = false
        tab.active = true

      return
  ]


.directive 'tab', ->
  restrict: 'EAC'
  require: '^tabset'
  replace: true
  transclude: true
  scope:
    title: '@'
  template:
    '''
      <section ng-class="{active: active}" ng-transclude></section>
    '''
  link: (scope, element, attrs, controller) ->
    controller.addTab scope
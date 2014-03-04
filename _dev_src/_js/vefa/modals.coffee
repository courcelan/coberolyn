angular.module('vefa.modals', [])

.directive 'vefaLightbox', ->
  restrict: 'AC' # <div vefa-lightbox>, <class="vefa-lightbox">
  replace: true
  transclude: true
  scope: {}
  template:
    """
      <div>
        <div ng-transclude ng-click="toggle()"></div>
        <div class="modal" ng-hide="!isOpen">
          <div class="modal--lightbox">
            <img ng-src="{{ src }}"/>
            <button class="ctrl--close" ng-click="toggle()">
              <i class="i--close"></i>
              <span>Close</span>
            </button>
          </div>
        </div>
      </div>
    """
  link: (scope, element, attrs) ->
    scope.isOpen ?= false

    scope.toggle = ->
      scope.isOpen = !scope.isOpen

    scope.$watch 'isOpen', ->
      if scope.isOpen
        scope.src ?= attrs.href

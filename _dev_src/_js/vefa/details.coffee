angular.module('vefa.details', [])

.run ($templateCache) ->
  $templateCache.put 'details.html',
    '''
    <div>
      <div class="panel" ng-show="isOpen">
        <div ng-transclude></div>
        <details-closer></details-closer>
      </div>
    </div>
    '''
  $templateCache.put 'details-closer.html',
    '''
    <button class="ctrl--close"
      type="button"
      ng-click="toggle()"
      ng-if="closeCtrl">
      <i class="i--close"></i>
      <span>Close</span>
    </button>
    '''


# when ng finds element, we have a details/accordion group
.directive 'detailsGroup', ->
  restrict: 'EAC' #<details-group>, <div details-group>, <class="details-group">
  scope: {}
  controller:
    [
      '$scope'
      '$element'
      ($scope, $element) ->
        group_members = [] # new set of group members

        @gotOpened = (selected) ->
          angular.forEach group_members, (member) ->
            # if this member is not the one opened: close it
            if selected != member
              member.isOpen = false

        @addDetails = (el) ->
          # hook for details element to add itself to group
          group_members.push el

        @closeAll = ->
          angular.forEach group_members, (member) ->
            # if this member is not the one opened: close it
            member.isOpen = false

        return
    ]
  link: (scope, element, attrs, controller) ->
    scope.name = "details-group"

# when ng finds the detail element, run the directive
.directive 'details', ->
  restrict: 'EC' # either <details> or class="details"
  require: '^?detailsGroup' # can be part of a group of details
  transclude: true
  replace: true
  scope: # need to create new scope for multiple details elements
    isOpen: '@open'
    closeCtrl: '@'
  templateUrl: 'details.html'
  controller:
    [
      '$scope'
      '$element'
      '$attrs'
      ($scope, $element, $attrs) ->
        $scope.name = "details"

        $scope.toggle = ->
          $scope.isOpen = !$scope.isOpen # toggle open closed (see template ^)

        $scope.$on "closeUpdate", (event) ->
          $scope.toggle()

        return
    ]
  link: (scope, element, attrs, controller) ->
    # find the summary control and show it outside of the transcluded piece
    ngElem = angular.element element
    summary = ngElem.find 'summary'
    ngElem.prepend summary
    # allow clicks on summary to toggle the panel
    summary.bind 'click', ->
      scope.$apply ->
        scope.toggle()
    # check to see if this is a part of a group (got to be a better way)
    if controller?
      controller.addDetails scope # add element to the group

    scope.$watch 'isOpen', ->
      # watch changes in isOpen value to set attribute on <details> (CSS hook)
      if scope.isOpen
        ngElem.attr "open", true
        # tell group this elem is open
        if controller?
          controller.gotOpened scope
      else
        ngElem.removeAttr "open"


.directive "detailsCloser", ->
  restrict: 'E'
  replace: true
  templateUrl: 'details-closer.html'
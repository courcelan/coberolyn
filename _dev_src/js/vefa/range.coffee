# vefa.range

tpl_vefaRange =
'''
<div class="ordered--range">
  <vefa-range-label></vefa-range-label>
  <div class="range--cmpt">
    <vefa-range-min></vefa-range-min>
    <vefa-range-track>
      <vefa-range-select
        ng-if="element.control">
      </vefa-range-select>
      <vefa-range-min-select
        ng-if="element.controls.min">
      </vefa-range-min-select>
      <vefa-range-max-select
        ng-if="element.controls.max">
      </vefa-range-select>
    </vefa-range-track>
    <vefa-range-max></vefa-range-max>
  </div>
</div>
'''

tpl_vefaRangeLabel =
'''
<label class="typ--support">
  {{ element.label }}
</label>
'''

tpl_vefaRangeMin =
'''
<span class="field-label-condensed range--min"
  ng-click="forceFloor()">
  {{ min|assign_percentage: element.is_percent }}
</span>
'''

tpl_vefaRangeMax =
'''
<span class="field-label-condensed range--max"
  ng-click="forceCeiling()">
  {{ max|assign_percentage: element.is_percent }}
</span>
'''

tpl_vefaRangeTrack =
'''
<div class="range--track"
  ng-click="assignValueFromTrack($event)"
  ng-transclude>
</div>
'''

tpl_vefaRangeSelect =
'''
<div class="range--select"
  value="{{ element.value|assign_percentage: element.is_percent }}"
  ng-class="{ active: draggable }">

  <input name="{{ element.control }}"
    type="text"
    ng-model="element.value"
    ng-hide="should_hide"/>
</div>
'''

tpl_vefaRangeMinSelect =
'''
<div class="range--select"
  value="{{ element.min_value }}"
  ng-class="{ active: draggable }">

  <input name="{{ element.controls.min }}"
  type="text"
  ng-model="element.min_value"
  ng-hide="should_hide"/>
</div>
'''

tpl_vefaRangeMaxSelect =
'''
<div class="range--select"
  value="{{ element.max_value }}"
  ng-class="{ active: draggable }">

  <input name="{{ element.controls.max }}"
    type="text"
    ng-model="element.max_value"
    ng-hide="should_hide"/>
</div>
'''


angular.module('vefa.range', [])


.filter 'assign_percentage', ->
  (input, percents) ->
    if percents
      return "#{ input }%"
    else
      return input


.directive 'vefaRange', ->
  restrict: 'CA'
  replace: true
  scope:
    id: '@rangeId'
  template: tpl_vefaRange
  controller: ($scope, $element, $attrs) ->
    $scope.should_hide = true
    if searchfilter[$scope.id]
      $scope.element = searchfilter[$scope.id]

      if !$scope.element.floor
        $scope.min = $scope.element.floor = 0
      else
        $scope.min = $scope.element.floor

      if !$scope.element.ceiling
        $scope.max = $scope.element.ceiling = 100
      else
        $scope.max = $scope.element.ceiling


    @setLeftBound = (bound) ->
      $scope.leftBound = bound

    @setRightBound = (bound) ->
      $scope.rightBound = bound

    @setPosition = ( elm, position ) ->
      # get half width of control element
      halfWidth = elm.prop("offsetWidth") / 2
      # get what percentage of track this is
      offset_percentage = (halfWidth / $scope.rightBound) * 100
      #subtract the sliver of offset
      position = position - offset_percentage
      #send out to CSS
      elm.css { left: "#{ position }%" }

    @setPositionInPX = ( elm, position ) ->
      halfWidth = elm.prop("offsetWidth") / 2
      position = position - halfWidth
      elm.css { left: "#{ position }px" }

    return

  link: (scope, elm, attrs, controller) ->

    scope.forceFloor = ->
      if scope.element.control
        scope.element.value = scope.element.floor
      else
        scope.element.min_value = scope.element.floor

    scope.forceCeiling = ->
      if scope.element.control
        scope.element.value = scope.element.ceiling
      else
        scope.element.max_value = scope.element.ceiling

    scope.updateRangeValue = (value, type) ->
      scope.element.value = value if !type
      scope.element.min_value = value if type is 'min'
      scope.element.max_value = value if type is 'max'
      scope.$digest()


.directive 'vefaRangeLabel', ->
  require: '^vefaRange'
  restrict: 'E'
  replace: true
  template: tpl_vefaRangeLabel


.directive 'vefaRangeMin', ->
  require: '^vefaRange'
  restrict: 'E'
  replace: true
  template: tpl_vefaRangeMin


.directive 'vefaRangeMax', ->
  require: '^vefaRange'
  restrict: 'E'
  replace: true
  template: tpl_vefaRangeMax


.directive 'vefaRangeTrack', ->
  require: '^vefaRange'
  restrict: 'E'
  replace: true
  transclude: true
  template: tpl_vefaRangeTrack
  link: (scope, elm, attrs, controller) ->
    controller.setLeftBound elm.prop('offsetLeft')
    controller.setRightBound elm.prop('offsetWidth')

    scope.assignValueFromTrack = ($event) ->
      if scope.element.control
        offset = ($event.offsetX / scope.rightBound)
        value = scope.element.ceiling * offset
        scope.element.value = parseInt( value )


.directive( 'vefaRangeSelect', [
  '$document'
  ($document) ->
    require: '^vefaRange'
    restrict: 'E'
    replace: true
    template: tpl_vefaRangeSelect
    link: (scope, elm, attrs, controller) ->
      pos =
        startX: 0
        initialMouseX: 0
      halfWidth = elm.prop("offsetWidth") / 2

      stopDrag = ($event) ->
        $document.unbind 'mousemove', drag
        $document.unbind 'mouseup', stopDrag
        scope.$emit 'rangeUpdate', scope.element.control, scope.element.value

      drag = ($event) ->
        dx = $event.clientX - pos.initialMouseX
        offset = (pos.startX + dx) / scope.rightBound
        scope.setPosition offset * 100
        scope.updateRangeValue parseInt( scope.element.ceiling * offset )

        if elm.prop('offsetLeft') <= 0
          scope.setPosition 0
          scope.updateRangeValue scope.element.floor
        else if (elm.prop('offsetLeft') + halfWidth) >= scope.rightBound
          scope.setPosition 100
          scope.updateRangeValue scope.element.ceiling

        return false

      elm.bind 'mousedown', ($event) ->
        pos.startX = elm.prop 'offsetLeft'
        pos.initialMouseX = $event.clientX
        $document.bind 'mousemove', drag
        $document.bind 'mouseup', stopDrag


      scope.setPosition = ( position ) ->
        controller.setPosition( elm, position )

      scope.getStartPoint = ->
        # get the relation of starting value to full value
        start_position = ( scope.element.startAt / scope.element.ceiling )

        # using the ratio value, apply an accept value to control
        scope.element.value = start_position * scope.element.ceiling

        # set control's position through a percentage
        scope.setPosition (start_position * 100)

      scope.$watch "element.value", ->
        computed_value = (scope.element.value / scope.element.ceiling) * 100
        scope.setPosition computed_value

      scope.getStartPoint()
  ])


.directive( 'vefaRangeMinSelect', [
  '$document'
  ($document) ->
    require: '^vefaRange'
    restrict: 'E'
    replace: true
    template: tpl_vefaRangeMinSelect
    link: (scope, elm, attrs, controller) ->
      pos =
        startX: 0
        initialMouseX: 0
      halfWidth = elm.prop("offsetWidth") / 2

      stopDrag = ($event) ->
        $document.unbind 'mousemove', drag
        $document.unbind 'mouseup', stopDrag
        scope.$emit 'rangeUpdate',
          scope.element.controls.min, scope.element.min_value

      drag = ($event) ->
        dx = $event.clientX - pos.initialMouseX
        offset = (pos.startX + dx) / scope.rightBound
        scope.setPosition offset * 100
        scope.updateRangeValue parseInt( scope.element.ceiling * offset ), 'min'

        if scope.element.min_value >= scope.element.max_value
          scope.setPosition scope.element.max_value
          scope.updateRangeValue scope.element.max_value, 'min'

        if elm.prop('offsetLeft') <= 0
          scope.setPosition 0
          scope.updateRangeValue scope.element.floor, 'min'
        else if (elm.prop('offsetLeft') + halfWidth) >= scope.rightBound
          scope.setPosition 100
          scope.updateRangeValue scope.element.ceiling, 'min'

        return false

      elm.bind 'mousedown', ($event) ->
        pos.startX = elm.prop 'offsetLeft'
        pos.initialMouseX = $event.clientX
        $document.bind 'mousemove', drag
        $document.bind 'mouseup', stopDrag


      scope.setPosition = ( position ) ->
        controller.setPosition( elm, position )

      scope.getStartPoint = ->
        # get the percentage of starting value to full value
        start_position = ( scope.element.startAt.min / scope.element.ceiling )
        # using the percentage value, apply an accept value to control
        scope.element.min_value = start_position * scope.element.ceiling
        scope.setPosition (start_position * 100)

      scope.$watch "element.min_value", ->
        computed_value = (scope.element.min_value / scope.element.ceiling) * 100
        scope.setPosition computed_value

      scope.getStartPoint()
  ])


.directive( 'vefaRangeMaxSelect', [
  '$document'
  ($document) ->
    require: '^vefaRange'
    restrict: 'E'
    replace: true
    template: tpl_vefaRangeMaxSelect
    link: (scope, elm, attrs, controller) ->
      pos =
        startX: 0
        initialMouseX: 0
      halfWidth = elm.prop("offsetWidth") / 2

      stopDrag = ($event) ->
        $document.unbind 'mousemove', drag
        $document.unbind 'mouseup', stopDrag
        scope.$emit 'rangeUpdate',
          scope.element.controls.max, scope.element.max_value

      drag = ($event) ->
        dx = $event.clientX - pos.initialMouseX
        offset = (pos.startX + dx) / scope.rightBound

        scope.setPosition offset * 100
        scope.updateRangeValue parseInt( scope.element.ceiling * offset ), 'max'

        if scope.element.max_value <= scope.element.min_value
          scope.setPosition scope.element.min_value
          scope.updateRangeValue scope.element.min_value, 'max'

        if elm.prop('offsetLeft') <= 0
          scope.setPosition 0
          scope.updateRangeValue scope.element.floor, 'max'
        else if (elm.prop('offsetLeft') + halfWidth) >= scope.rightBound
          scope.setPosition 100
          scope.updateRangeValue scope.element.ceiling, 'max'

        return false

      elm.bind 'mousedown', ($event) ->
        pos.startX = elm.prop 'offsetLeft'
        pos.initialMouseX = $event.clientX
        $document.bind 'mousemove', drag
        $document.bind 'mouseup', stopDrag


      scope.setPosition = ( position ) ->
        controller.setPosition( elm, position )

      scope.setPositionInPX = ( position ) ->
        controller.setPositionInPX( elm, position )

      scope.getStartPoint = ->
        # get the percentage of starting value to full value
        start_position = ( scope.element.startAt.max / scope.element.ceiling )
        # using the percentage value, apply an accept value to control
        scope.element.max_value = start_position * scope.element.ceiling
        scope.setPosition (start_position * 100)

      scope.$watch "element.max_value", ->
        computed_value = (scope.element.max_value / scope.element.ceiling) * 100
        scope.setPosition computed_value

      scope.getStartPoint()
  ])
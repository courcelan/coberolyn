angular.module('vefa.checkboxes', [])


.run ($templateCache) ->
  $templateCache.put 'selectAll.html',
    '''
    <label>
      <input type="checkbox"
        ng-hide="true"
        ng-checked="model.isAllChecked"
        ng-model="model.isAllChecked"
        ng-change="switch()" />
      {{ label }}
    </label>
    '''
  $templateCache.put 'choiceInput.html',
  '''
  <input
    ng-checked="el.isChecked"
    ng-model="el.isChecked"
    ng-change="switch()"/>
  '''


.directive 'vefaCheckboxGroup', ->
  restrict: 'EAC'
  scope: {}
  controller: ($scope) ->
    model:
      isAllChecked: false
    checkGroup: (status) ->
      $scope.$broadcast 'selectAllUpdate',  status

  link: (scope) ->
    scope.selectAll = false


.directive 'vefaOrderedSingleChoice', ->
  restrict: 'AC'
  replace: true
  scope: {}
  templateUrl: 'choiceInput.html'
  link: (scope, element, attrs) ->
    el =
      isChecked: ""

    scope.el = el
    scope.switch = ->
      value = if el.isChecked then attrs.value else el.isChecked
      scope.$emit 'singleChoiceUpdate', attrs.name, value


.directive 'vefaOrderedMultiChoice', ->
  restrict: 'AC'
  replace: true
  require: '^?vefaCheckboxGroup'
  scope:
    selectAll: '='
  templateUrl: 'choiceInput.html'
  link: (scope, element, attrs) ->
    el =
      isChecked: ""
      remove: false

    scope.el = el
    scope.switch = ->
      el.remove = false
      el.remove = true unless el.isChecked
      scope.$emit 'multiChoiceUpdate', attrs.name, attrs.value, el.remove

    scope.$on 'selectAllUpdate', (event, status) ->
      el.isChecked = status
      scope.switch()


.directive 'vefaSelectAll', ->
  restrict: 'EAC' # <select-all>, <div select-all>, <class="select-all">
  replace: true
  require: '^vefaCheckboxGroup'
  templateUrl: 'selectAll.html'
  scope: {}
  controller: ($scope) ->
    model =
      isAllChecked: false
      checkLabel: "Check all"
      uncheckLabel: "Uncheck all"

    $scope.model = model
    $scope.labelSwitch = ->
      if model.isAllChecked
      then $scope.label = model.uncheckLabel
      else $scope.label = model.checkLabel

    return

  link: (scope, element, attrs, controller) ->
    scope.labelSwitch()
    scope.switch = =>
      scope.labelSwitch()
      controller.checkGroup scope.model.isAllChecked

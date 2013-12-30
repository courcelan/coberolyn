xdescribe 'Vefa.Checkboxes:', ->
  mod = {}

  before ->
    mod = module('vefa.checkboxes')

  it 'should be registered', ->
    expect(mod)
      .not.to.equal null

  it 'should have vefaSelectAll', ->
    expect(mod.vefaSelectAll)
      .not.to.equal null

  describe 'vefaSelectAll:', ->
    $scope = {}
    element = {}

    beforeEach module('vefa.checkboxes')
    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope
      element = angular.element("<vefa-select-all></vefa-select-all>")
      $compile(element)($rootScope)

    it 'should load with allChecked false', ->
      console.log element
      expect($scope.model.isAllChecked).to.be false

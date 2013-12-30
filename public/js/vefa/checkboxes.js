angular.module('vefa.checkboxes', []).run(function($templateCache) {
  $templateCache.put('selectAll.html', '<label>\n  <input type="checkbox"\n    ng-hide="true"\n    ng-checked="model.isAllChecked"\n    ng-model="model.isAllChecked"\n    ng-change="switch()" />\n  {{ label }}\n</label>');
  return $templateCache.put('choiceInput.html', '<input\n  ng-checked="el.isChecked"\n  ng-model="el.isChecked"\n  ng-change="switch()"/>');
}).directive('vefaCheckboxGroup', function() {
  return {
    restrict: 'EAC',
    scope: {},
    controller: function($scope) {
      return {
        model: {
          isAllChecked: false
        },
        checkGroup: function(status) {
          return $scope.$broadcast('selectAllUpdate', status);
        }
      };
    },
    link: function(scope) {
      return scope.selectAll = false;
    }
  };
}).directive('vefaOrderedSingleChoice', function() {
  return {
    restrict: 'AC',
    replace: true,
    scope: {},
    templateUrl: 'choiceInput.html',
    link: function(scope, element, attrs) {
      var el;
      el = {
        isChecked: ""
      };
      scope.el = el;
      return scope["switch"] = function() {
        var value;
        value = el.isChecked ? attrs.value : el.isChecked;
        return scope.$emit('singleChoiceUpdate', attrs.name, value);
      };
    }
  };
}).directive('vefaOrderedMultiChoice', function() {
  return {
    restrict: 'AC',
    replace: true,
    require: '^?vefaCheckboxGroup',
    scope: {
      selectAll: '='
    },
    templateUrl: 'choiceInput.html',
    link: function(scope, element, attrs) {
      var el;
      el = {
        isChecked: "",
        remove: false
      };
      scope.el = el;
      scope["switch"] = function() {
        el.remove = false;
        if (!el.isChecked) {
          el.remove = true;
        }
        return scope.$emit('multiChoiceUpdate', attrs.name, attrs.value, el.remove);
      };
      return scope.$on('selectAllUpdate', function(event, status) {
        el.isChecked = status;
        return scope["switch"]();
      });
    }
  };
}).directive('vefaSelectAll', function() {
  return {
    restrict: 'EAC',
    replace: true,
    require: '^vefaCheckboxGroup',
    templateUrl: 'selectAll.html',
    scope: {},
    controller: function($scope) {
      var model;
      model = {
        isAllChecked: false,
        checkLabel: "Check all",
        uncheckLabel: "Uncheck all"
      };
      $scope.model = model;
      $scope.labelSwitch = function() {
        if (model.isAllChecked) {
          return $scope.label = model.uncheckLabel;
        } else {
          return $scope.label = model.checkLabel;
        }
      };
    },
    link: function(scope, element, attrs, controller) {
      var _this = this;
      scope.labelSwitch();
      return scope["switch"] = function() {
        scope.labelSwitch();
        return controller.checkGroup(scope.model.isAllChecked);
      };
    }
  };
});

xdescribe('Vefa.Checkboxes:', function() {
  var mod;
  mod = {};
  before(function() {
    return mod = module('vefa.checkboxes');
  });
  it('should be registered', function() {
    return expect(mod).not.to.equal(null);
  });
  it('should have vefaSelectAll', function() {
    return expect(mod.vefaSelectAll).not.to.equal(null);
  });
  return describe('vefaSelectAll:', function() {
    var $scope, element;
    $scope = {};
    element = {};
    beforeEach(module('vefa.checkboxes'));
    beforeEach(inject(function($compile, $rootScope) {
      $scope = $rootScope;
      element = angular.element("<vefa-select-all></vefa-select-all>");
      return $compile(element)($rootScope);
    }));
    return it('should load with allChecked false', function() {
      console.log(element);
      return expect($scope.model.isAllChecked).to.be(false);
    });
  });
});

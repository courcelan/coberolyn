var tpl_vefaRange, tpl_vefaRangeLabel, tpl_vefaRangeMax, tpl_vefaRangeMaxSelect, tpl_vefaRangeMin, tpl_vefaRangeMinSelect, tpl_vefaRangeSelect, tpl_vefaRangeTrack;

tpl_vefaRange = '<div class="ordered--range">\n  <vefa-range-label></vefa-range-label>\n  <div class="range--cmpt">\n    <vefa-range-min></vefa-range-min>\n    <vefa-range-track>\n      <vefa-range-select\n        ng-if="element.control">\n      </vefa-range-select>\n      <vefa-range-min-select\n        ng-if="element.controls.min">\n      </vefa-range-min-select>\n      <vefa-range-max-select\n        ng-if="element.controls.max">\n      </vefa-range-select>\n    </vefa-range-track>\n    <vefa-range-max></vefa-range-max>\n  </div>\n</div>';

tpl_vefaRangeLabel = '<label class="typ--support">\n  {{ element.label }}\n</label>';

tpl_vefaRangeMin = '<span class="field-label-condensed range--min"\n  ng-click="forceFloor()">\n  {{ min|assign_percentage: element.is_percent }}\n</span>';

tpl_vefaRangeMax = '<span class="field-label-condensed range--max"\n  ng-click="forceCeiling()">\n  {{ max|assign_percentage: element.is_percent }}\n</span>';

tpl_vefaRangeTrack = '<div class="range--track"\n  ng-click="assignValueFromTrack($event)"\n  ng-transclude>\n</div>';

tpl_vefaRangeSelect = '<div class="range--select"\n  value="{{ element.value|assign_percentage: element.is_percent }}"\n  ng-class="{ active: draggable }">\n\n  <input name="{{ element.control }}"\n    type="text"\n    ng-model="element.value"\n    ng-hide="should_hide"/>\n</div>';

tpl_vefaRangeMinSelect = '<div class="range--select"\n  value="{{ element.min_value }}"\n  ng-class="{ active: draggable }">\n\n  <input name="{{ element.controls.min }}"\n  type="text"\n  ng-model="element.min_value"\n  ng-hide="should_hide"/>\n</div>';

tpl_vefaRangeMaxSelect = '<div class="range--select"\n  value="{{ element.max_value }}"\n  ng-class="{ active: draggable }">\n\n  <input name="{{ element.controls.max }}"\n    type="text"\n    ng-model="element.max_value"\n    ng-hide="should_hide"/>\n</div>';

angular.module('vefa.range', []).filter('assign_percentage', function() {
  return function(input, percents) {
    if (percents) {
      return "" + input + "%";
    } else {
      return input;
    }
  };
}).directive('vefaRange', function() {
  return {
    restrict: 'CA',
    replace: true,
    scope: {
      id: '@rangeId'
    },
    template: tpl_vefaRange,
    controller: function($scope, $element, $attrs) {
      $scope.should_hide = true;
      if (searchfilter[$scope.id]) {
        $scope.element = searchfilter[$scope.id];
        if (!$scope.element.floor) {
          $scope.min = $scope.element.floor = 0;
        } else {
          $scope.min = $scope.element.floor;
        }
        if (!$scope.element.ceiling) {
          $scope.max = $scope.element.ceiling = 100;
        } else {
          $scope.max = $scope.element.ceiling;
        }
      }
      this.setLeftBound = function(bound) {
        return $scope.leftBound = bound;
      };
      this.setRightBound = function(bound) {
        return $scope.rightBound = bound;
      };
      this.setPosition = function(elm, position) {
        var halfWidth, offset_percentage;
        halfWidth = elm.prop("offsetWidth") / 2;
        offset_percentage = (halfWidth / $scope.rightBound) * 100;
        position = position - offset_percentage;
        return elm.css({
          left: "" + position + "%"
        });
      };
      this.setPositionInPX = function(elm, position) {
        var halfWidth;
        halfWidth = elm.prop("offsetWidth") / 2;
        position = position - halfWidth;
        return elm.css({
          left: "" + position + "px"
        });
      };
    },
    link: function(scope, elm, attrs, controller) {
      scope.forceFloor = function() {
        if (scope.element.control) {
          return scope.element.value = scope.element.floor;
        } else {
          return scope.element.min_value = scope.element.floor;
        }
      };
      scope.forceCeiling = function() {
        if (scope.element.control) {
          return scope.element.value = scope.element.ceiling;
        } else {
          return scope.element.max_value = scope.element.ceiling;
        }
      };
      return scope.updateRangeValue = function(value, type) {
        if (!type) {
          scope.element.value = value;
        }
        if (type === 'min') {
          scope.element.min_value = value;
        }
        if (type === 'max') {
          scope.element.max_value = value;
        }
        return scope.$digest();
      };
    }
  };
}).directive('vefaRangeLabel', function() {
  return {
    require: '^vefaRange',
    restrict: 'E',
    replace: true,
    template: tpl_vefaRangeLabel
  };
}).directive('vefaRangeMin', function() {
  return {
    require: '^vefaRange',
    restrict: 'E',
    replace: true,
    template: tpl_vefaRangeMin
  };
}).directive('vefaRangeMax', function() {
  return {
    require: '^vefaRange',
    restrict: 'E',
    replace: true,
    template: tpl_vefaRangeMax
  };
}).directive('vefaRangeTrack', function() {
  return {
    require: '^vefaRange',
    restrict: 'E',
    replace: true,
    transclude: true,
    template: tpl_vefaRangeTrack,
    link: function(scope, elm, attrs, controller) {
      controller.setLeftBound(elm.prop('offsetLeft'));
      controller.setRightBound(elm.prop('offsetWidth'));
      return scope.assignValueFromTrack = function($event) {
        var offset, value;
        if (scope.element.control) {
          offset = $event.offsetX / scope.rightBound;
          value = scope.element.ceiling * offset;
          return scope.element.value = parseInt(value);
        }
      };
    }
  };
}).directive('vefaRangeSelect', [
  '$document', function($document) {
    return {
      require: '^vefaRange',
      restrict: 'E',
      replace: true,
      template: tpl_vefaRangeSelect,
      link: function(scope, elm, attrs, controller) {
        var drag, halfWidth, pos, stopDrag;
        pos = {
          startX: 0,
          initialMouseX: 0
        };
        halfWidth = elm.prop("offsetWidth") / 2;
        stopDrag = function($event) {
          $document.unbind('mousemove', drag);
          $document.unbind('mouseup', stopDrag);
          return scope.$emit('rangeUpdate', scope.element.control, scope.element.value);
        };
        drag = function($event) {
          var dx, offset;
          dx = $event.clientX - pos.initialMouseX;
          offset = (pos.startX + dx) / scope.rightBound;
          scope.setPosition(offset * 100);
          scope.updateRangeValue(parseInt(scope.element.ceiling * offset));
          if (elm.prop('offsetLeft') <= 0) {
            scope.setPosition(0);
            scope.updateRangeValue(scope.element.floor);
          } else if ((elm.prop('offsetLeft') + halfWidth) >= scope.rightBound) {
            scope.setPosition(100);
            scope.updateRangeValue(scope.element.ceiling);
          }
          return false;
        };
        elm.bind('mousedown', function($event) {
          pos.startX = elm.prop('offsetLeft');
          pos.initialMouseX = $event.clientX;
          $document.bind('mousemove', drag);
          return $document.bind('mouseup', stopDrag);
        });
        scope.setPosition = function(position) {
          return controller.setPosition(elm, position);
        };
        scope.getStartPoint = function() {
          var start_position;
          start_position = scope.element.startAt / scope.element.ceiling;
          scope.element.value = start_position * scope.element.ceiling;
          return scope.setPosition(start_position * 100);
        };
        scope.$watch("element.value", function() {
          var computed_value;
          computed_value = (scope.element.value / scope.element.ceiling) * 100;
          return scope.setPosition(computed_value);
        });
        return scope.getStartPoint();
      }
    };
  }
]).directive('vefaRangeMinSelect', [
  '$document', function($document) {
    return {
      require: '^vefaRange',
      restrict: 'E',
      replace: true,
      template: tpl_vefaRangeMinSelect,
      link: function(scope, elm, attrs, controller) {
        var drag, halfWidth, pos, stopDrag;
        pos = {
          startX: 0,
          initialMouseX: 0
        };
        halfWidth = elm.prop("offsetWidth") / 2;
        stopDrag = function($event) {
          $document.unbind('mousemove', drag);
          $document.unbind('mouseup', stopDrag);
          return scope.$emit('rangeUpdate', scope.element.controls.min, scope.element.min_value);
        };
        drag = function($event) {
          var dx, offset;
          dx = $event.clientX - pos.initialMouseX;
          offset = (pos.startX + dx) / scope.rightBound;
          scope.setPosition(offset * 100);
          scope.updateRangeValue(parseInt(scope.element.ceiling * offset), 'min');
          if (scope.element.min_value >= scope.element.max_value) {
            scope.setPosition(scope.element.max_value);
            scope.updateRangeValue(scope.element.max_value, 'min');
          }
          if (elm.prop('offsetLeft') <= 0) {
            scope.setPosition(0);
            scope.updateRangeValue(scope.element.floor, 'min');
          } else if ((elm.prop('offsetLeft') + halfWidth) >= scope.rightBound) {
            scope.setPosition(100);
            scope.updateRangeValue(scope.element.ceiling, 'min');
          }
          return false;
        };
        elm.bind('mousedown', function($event) {
          pos.startX = elm.prop('offsetLeft');
          pos.initialMouseX = $event.clientX;
          $document.bind('mousemove', drag);
          return $document.bind('mouseup', stopDrag);
        });
        scope.setPosition = function(position) {
          return controller.setPosition(elm, position);
        };
        scope.getStartPoint = function() {
          var start_position;
          start_position = scope.element.startAt.min / scope.element.ceiling;
          scope.element.min_value = start_position * scope.element.ceiling;
          return scope.setPosition(start_position * 100);
        };
        scope.$watch("element.min_value", function() {
          var computed_value;
          computed_value = (scope.element.min_value / scope.element.ceiling) * 100;
          return scope.setPosition(computed_value);
        });
        return scope.getStartPoint();
      }
    };
  }
]).directive('vefaRangeMaxSelect', [
  '$document', function($document) {
    return {
      require: '^vefaRange',
      restrict: 'E',
      replace: true,
      template: tpl_vefaRangeMaxSelect,
      link: function(scope, elm, attrs, controller) {
        var drag, halfWidth, pos, stopDrag;
        pos = {
          startX: 0,
          initialMouseX: 0
        };
        halfWidth = elm.prop("offsetWidth") / 2;
        stopDrag = function($event) {
          $document.unbind('mousemove', drag);
          $document.unbind('mouseup', stopDrag);
          return scope.$emit('rangeUpdate', scope.element.controls.max, scope.element.max_value);
        };
        drag = function($event) {
          var dx, offset;
          dx = $event.clientX - pos.initialMouseX;
          offset = (pos.startX + dx) / scope.rightBound;
          scope.setPosition(offset * 100);
          scope.updateRangeValue(parseInt(scope.element.ceiling * offset), 'max');
          if (scope.element.max_value <= scope.element.min_value) {
            scope.setPosition(scope.element.min_value);
            scope.updateRangeValue(scope.element.min_value, 'max');
          }
          if (elm.prop('offsetLeft') <= 0) {
            scope.setPosition(0);
            scope.updateRangeValue(scope.element.floor, 'max');
          } else if ((elm.prop('offsetLeft') + halfWidth) >= scope.rightBound) {
            scope.setPosition(100);
            scope.updateRangeValue(scope.element.ceiling, 'max');
          }
          return false;
        };
        elm.bind('mousedown', function($event) {
          pos.startX = elm.prop('offsetLeft');
          pos.initialMouseX = $event.clientX;
          $document.bind('mousemove', drag);
          return $document.bind('mouseup', stopDrag);
        });
        scope.setPosition = function(position) {
          return controller.setPosition(elm, position);
        };
        scope.setPositionInPX = function(position) {
          return controller.setPositionInPX(elm, position);
        };
        scope.getStartPoint = function() {
          var start_position;
          start_position = scope.element.startAt.max / scope.element.ceiling;
          scope.element.max_value = start_position * scope.element.ceiling;
          return scope.setPosition(start_position * 100);
        };
        scope.$watch("element.max_value", function() {
          var computed_value;
          computed_value = (scope.element.max_value / scope.element.ceiling) * 100;
          return scope.setPosition(computed_value);
        });
        return scope.getStartPoint();
      }
    };
  }
]);

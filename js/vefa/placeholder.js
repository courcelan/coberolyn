var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('vefa.placeholder', []).directive('placeholder', function() {
  if (__indexOf.call(document.createElement('input'), 'placeholder') >= 0) {
    return;
  }
  return function(scope, element) {
    var placeholder;
    placeholder = element.attr('placeholder');
    element.bind('focus', function() {
      if (element.val() === placeholder) {
        return element.val('');
      }
    });
    element.bind('blur', function() {
      if (element.val().length === 0) {
        return element.val(placeholder);
      }
    });
    element.val(placeholder);
  };
});

angular.module('app.djangoAjax', []).config([
  '$httpProvider', function(provider) {
    var djangoCSRF;
    if (document.querySelectorAll('input[name=csrfmiddlewaretoken]')[0] != null) {
      djangoCSRF = document.querySelectorAll('input[name=csrfmiddlewaretoken]')[0].value;
      provider.defaults.headers.common['X-CSRFToken'] = djangoCSRF;
    }
    provider.defaults.headers.common["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8";
    return provider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
  }
]).service('$queryService', function() {
  this.param = function(obj) {
    var fullSubName, i, innerObj, name, query, subName, subValue, value, _i, _len;
    query = '';
    for (name in obj) {
      value = obj[name];
      if (angular.isArray(value)) {
        for (i = _i = 0, _len = value.length; _i < _len; i = ++_i) {
          subValue = value[i];
          fullSubName = "" + name;
          innerObj = {};
          innerObj[fullSubName] = subValue;
          query += "" + (this.param(innerObj)) + "&";
        }
      } else if (angular.isObject(value)) {
        for (subName in value) {
          subValue = value[subName];
          fullSubName = "" + name + "[" + subName + "]";
          innerObj = {};
          innerObj[fullSubName] = subValue;
          query += "" + (this.param(innerObj)) + "&";
        }
      } else if (value != null) {
        query += "" + (encodeURIComponent(name)) + "=" + (encodeURIComponent(value)) + "&";
      }
    }
    if (query.length) {
      return query.substr(0, query.length - 1);
    } else {
      return query;
    }
  };
  return this;
});

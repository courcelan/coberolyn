# Django Ajax module
# supply module to enable ajax communication with a django-based application
angular.module('app.djangoAjax', [])

# configure the headers for correct communication
.config([
  '$httpProvider'
  (provider) ->

    # get the needed csrf middleware token and apply it to the headers
    #
    # TODO: looks like Django adds csrf as a cookie, but can we get it without
    # needing ngCookie dependency?

    if document.querySelectorAll('input[name=csrfmiddlewaretoken]')[0]?
      djangoCSRF = document
        .querySelectorAll('input[name=csrfmiddlewaretoken]')[0].value

      provider.defaults.headers.common['X-CSRFToken'] = djangoCSRF

    # angular generally sents data as application/json
    # we can change this to familiar form-urlencoded
    provider.defaults.headers.common["Content-Type"] =
      "application/x-www-form-urlencoded; charset=UTF-8"

    # Django likes to check for whether something is requested via ajax
    # Angular doesn't provide this out-of-box, so we add it in explicitly
    #
    provider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'

])

.service '$queryService', ->
  # taken in part from Make AngularJS $http service
  # behave like jQuery.ajax: bit.ly/WDwi4G
  @param = (obj) ->
    query = ''

    for name, value of obj
      if angular.isArray value
        for subValue, i in value
          fullSubName = "#{name}"
          innerObj = {}
          innerObj[fullSubName] = subValue
          query += "#{@param(innerObj)}&"

      else if angular.isObject value
        for subName, subValue of value
          fullSubName = "#{name}[#{subName}]"
          innerObj = {}
          innerObj[fullSubName] = subValue
          query += "#{@param(innerObj)}&"

      else if value?
        query += "#{encodeURIComponent(name)}=#{encodeURIComponent(value)}&"

    return if query.length then query.substr(0, query.length - 1) else query

  return this
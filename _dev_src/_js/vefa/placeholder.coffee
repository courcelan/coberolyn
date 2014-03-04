angular.module('vefa.placeholder', [])
  .directive 'placeholder', ->

    # stop process if native functionality available
    if 'placeholder' in document.createElement 'input'
      return

    return (scope, element) ->
      placeholder = element.attr('placeholder')

      # set focus even to remove placeholder
      element.bind 'focus', ->
        if element.val() is placeholder
          element.val( '' )

      # set blur event to add placeholder into place if no user value given
      element.bind 'blur', ->
        if element.val().length is 0
          element.val( placeholder )

      # on initial linking set element value to placeholder
      element.val( placeholder )

      return
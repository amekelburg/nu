$ ->
  $("body").on "click", ".show-hide", (e) ->
    e.preventDefault()
    trigger = $(this)
    hidden = trigger.text() == 'Show'
    drawer = $(trigger.data('drawer'))

    if hidden
      trigger.text 'Hide'
      drawer.removeClass 'hide'
    else
      trigger.text 'Show'
      drawer.addClass 'hide'


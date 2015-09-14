$ ->
  $(".js-error-more-info").on "click", (e) ->
    e.preventDefault()
    $(".details").toggleClass('hide')

$ ->
  return if $("body#libraries_show, body#libraries_manage").length == 0

  $(".js-copy").on "click", (e) ->
    e.preventDefault()
    $(".js-copy-experiment").toggleClass("hide")

  $(".js-cancel").on "click", (e) ->
    e.preventDefault()
    $(".js-copy-experiment").addClass("hide")


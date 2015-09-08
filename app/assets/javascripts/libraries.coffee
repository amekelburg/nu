$ ->
  return if $("body#libraries_show").length == 0

  # start loading team and experiments data
  $.getJSON gon.libraryDetailsUrl, (data) ->
    $("#experiments-section .body").html(data.experiments_html)

  $(".js-copy").on "click", (e) ->
    e.preventDefault()
    $(".js-copy-experiment").toggleClass("hide")

  $(".js-cancel").on "click", (e) ->
    e.preventDefault()
    $(".js-copy-experiment").addClass("hide")


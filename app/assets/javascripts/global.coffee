$ ->
  $(".noclick").on("click", (e) -> e.preventDefault())
  $("[data-toggle=popover]").popover(html: true)
  $("[data-toggle=tooltip]:not(.help)").tooltip(html: true)



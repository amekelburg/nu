$ ->
  return if $("body#experiments_show, body#experiments_manage").length == 0
  $("pre.view").each (i, e) ->
    w = $(e).parents("td").width()
    $(e).width(w - 20 - 2)

  new MoreLess null, (id, row) ->

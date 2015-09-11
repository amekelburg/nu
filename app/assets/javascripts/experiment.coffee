$ ->
  return if $("body#experiments_show, body#experiments_manage").length == 0
  new MoreLess null, (id, row) ->

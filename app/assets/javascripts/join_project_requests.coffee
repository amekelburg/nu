$ ->
  return if $("body#join_project_requests_index").length == 0
  new MoreLess null, (id, row) ->

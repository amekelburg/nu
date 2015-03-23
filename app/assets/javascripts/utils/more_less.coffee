class window.MoreLess
  constructor: (scope = 'body', moreCallback = null) ->
    $("a.more", scope).on "click", (e) ->
      e.preventDefault()
      el = $(this)
      id = el.data('id')
      row = $("tr[data-more-id='#{id}']", scope)
      row.removeClass('hide')
      $("a.less[data-pid='#{id}']", scope).removeClass('hide')
      el.addClass('hide')
      moreCallback(id, row) if moreCallback


    $("a.less").on "click", (e) ->
      e.preventDefault()
      el = $(this)
      id = el.data('id')
      $("tr[data-more-pid='#{id}']", scope).addClass('hide')
      $("a.more[data-pid='#{id}']", scope).removeClass('hide')
      el.addClass('hide')
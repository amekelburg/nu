$ ->
  updateSection = (link) ->
    less = $(".icon.less", link)
    more = $(".icon.more", link)
    sect = $(link.data('target'))

    if link.data('expanded')
      more.hide()
      less.show()
      sect.removeClass('collapse')
    else
      less.hide()
      more.show()
      sect.addClass('collapse')

  $("body").on "click", "[data-toggle=expand]", (e) ->
    e.preventDefault()
    link = $(this)
    link.data('expanded', !link.data('expanded'))
    $(".icon", link).removeClass('hide')
    updateSection(link)


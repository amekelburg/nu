$ ->
  $("[data-toggle=expand]").each (i, l) ->
    link = $(l)
    less = $(".icon.less", link)
    more = $(".icon.more", link)
    sect = $(link.data('target'))

    updateSection = ->
      if link.data('expanded')
        more.hide()
        less.show()
        sect.removeClass('collapse')
      else
        less.hide()
        more.show()
        sect.addClass('collapse')

    link.on 'click', (e) ->
      e.preventDefault()
      link.data('expanded', !link.data('expanded'))
      updateSection()

    updateSection()

    # remove initial hide class
    $(".icon", link).removeClass('hide')

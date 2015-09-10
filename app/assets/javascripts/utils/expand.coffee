$ ->
  updateSection = (link) ->
    sect = $(link.data('target'))

    if link.data('expanded')
      link.text('expand_less')
      sect.removeClass('collapse')
    else
      link.text('expand_more')
      sect.addClass('collapse')

  $("body").on "click", "[data-toggle=expand]", (e) ->
    e.preventDefault()
    link = $(this)
    link.data('expanded', !link.data('expanded'))
    updateSection(link)


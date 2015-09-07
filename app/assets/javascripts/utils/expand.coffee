$ ->
  $("[data-toggle=expand]").each (i, l) ->
    link = $(l)
    span = $('span', l) || $("<span>").addClass('glyphicon').appendTo(link)
    sect = $(link.data('target'))

    updateSection = ->
      if link.data('expanded')
        span.removeClass('glyphicon-resize-full').addClass('glyphicon-resize-small')
        sect.removeClass('collapse')
      else
        span.removeClass('glyphicon-resize-small').addClass('glyphicon-resize-full')
        sect.addClass('collapse')

    link.on 'click', (e) ->
      e.preventDefault()
      link.data('expanded', !link.data('expanded'))
      updateSection()

    updateSection()

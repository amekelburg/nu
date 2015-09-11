$ ->
  # read-only project info sections switch
  $(".submenu a.js-section-switch").on 'click', (e) ->
    e.preventDefault()
    sid = $(this).attr('href')
    $("[id$=-section]").addClass('hide')
    $("a.js-section-switch").removeClass('active')
    $(this).addClass('active')
    $(sid).removeClass('hide')

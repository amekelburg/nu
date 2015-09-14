$ ->
  $("body").on "click", "[data-bbconfirm]", (e) ->
    link = $(this)

    if !link.data('confirmed')
      e.preventDefault()
    
      msg = $(this).data('bbconfirm')

      bootbox.confirm msg, (confirmed) ->
        if confirmed
          link.data('confirmed', true)
          link[0].click()

      return false

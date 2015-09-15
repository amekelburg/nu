$ ->
  $("body").on "click", "[data-bbconfirm]", (e) ->
    link = $(this)

    if !link.data('confirmed')
      e.preventDefault()
    
      msg = $(this).data('bbconfirm')

      bootbox.dialog
        message: msg
        buttons:
          success:
            label: 'Yes'
            className: 'btn-default btn-sm'
            callback: ->
              link.data 'confirmed', true
              link[0].click()
          main:
            label: 'No'
            className: 'btn-primary btn-sm'
        
      return false

$ ->
  $("[data-modal-id]").each (i, el) ->
    $(el).on "click", (e) ->
      e.preventDefault()
      modalId = $(e.target).data('modalId')
      $("##{modalId}").modal('toggle')

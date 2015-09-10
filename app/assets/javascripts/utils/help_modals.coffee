$ ->
  $("body").on "click", "[data-modal-id]", (e) ->
    e.preventDefault()
    modalId = $(this).data('modalId')
    $("##{modalId}").modal('toggle')

$ ->
  restartTimer = (tt) ->
    timer = tt.data('timer')
    clearTimeout(timer) if timer
    tt.data('timer', setTimeout( (-> tt.tooltip('hide'); tt.data('timer', false) ), 500))

  timers = {}
  help = $("[data-toggle=tooltip].help").tooltip(html: true, trigger: 'manual')
  help.on "mouseenter", (e) ->
    timer = $(this).data('timer')
    if timer
      clearTimeout(timer)
      $(this).data('timer', false)
    else
      $(this).tooltip('show')

  help.on "mouseout", (e) ->
    restartTimer($(this))

  $("body").on "mouseenter", "div.tooltip", (e) ->
    tid = $(this).attr('id')
    trigger = $("[aria-describedby=#{tid}].help")
    if trigger
      timer = trigger.data('timer')
      if timer
        clearTimeout(timer)
        trigger.data('timer', null)

  $("body").on "mouseout", "div.tooltip", (e) ->
    tid = $(this).attr('id')
    trigger = $("[aria-describedby=#{tid}].help")
    unless e.toElement == trigger or $.contains(this, e.toElement)
      restartTimer(trigger)

  $("body").on "click", "[data-modal-id]", (e) ->
    e.preventDefault()
    modalId = $(this).data('modalId')
    $("##{modalId}").modal('toggle')

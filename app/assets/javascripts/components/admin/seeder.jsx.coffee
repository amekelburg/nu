# -----------------------------------------------------------------------------
# Actions
# -----------------------------------------------------------------------------

actStartSeeding = Reflux.createAction()

# -----------------------------------------------------------------------------
# Stores
# -----------------------------------------------------------------------------

Log = Reflux.createStore
  init: ->
    @log = []
    @listenTo actStartSeeding, @onStartSeeding

  getInitialState: -> @log

  onStartSeeding: (pass) ->
    events = new EventSource("/admin/seed/perform?pass=#{pass}")

    events.addEventListener 'open', ->
      console.log 'open'

    events.addEventListener 'message', (e) =>
      @log.push e.data
      @trigger(@log)

    events.addEventListener 'error', (e) =>
      events.close()
      @log.push "ERROR: #{e.data}"
      @trigger(@log)

    events.addEventListener 'finish', =>
      events.close()
      @log.push ""
      @log.push "FINISHED: ok"
      @trigger(@log)


# -----------------------------------------------------------------------------
# Components
# -----------------------------------------------------------------------------

@Seeder = React.createClass
  mixins: [
    Reflux.connect Log, 'log'
  ]

  componentDidMount: ->
    actStartSeeding(gon.password)

  render: ->
    data = @state.log.join("\n")

    `<pre>{data}</pre>`



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
    events = new EventSource("/admin/seed/perform?pass=#{encodeURIComponent(pass)}")

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

  getInitialState: ->
    return { password: null }

  startSeeding: (pass) ->
    @setState({ password: pass })
    actStartSeeding(pass)

  render: ->
    console.log @state
    if @state.password?
      data = @state.log.join("\n")
      `<pre>{data}</pre>`
    else
      `<PasswordBox onClick={this.startSeeding}/>`

PasswordBox = React.createClass
  handleSubmit: (e) ->
    e.preventDefault()
    @props.onClick($(React.findDOMNode(this.refs.password)).val())

  render: ->
    `<form action='#' className='form'>
      <div className='form-group'>
        <label className='control-label'>deterboss password:</label>
        <input id='password' name='password' type='text' ref='password' className='form-control' />
      </div>
      <input type='submit' className='btn btn-default' value='Start Seeding' onClick={this.handleSubmit} />
    </form>`

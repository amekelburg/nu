actStartPolling = Reflux.createAction()

DescriptionStore = Reflux.createStore
  init: ->
    @data = gon.description
    @listenTo actStartPolling, @onStartPolling

  getInitialState: -> @data

  onStartPolling: ->
    @interval = setInterval(@refresh, gon.refresh_rate / 3)

  refresh: ->
    console.log "refresh"
    $.getJSON gon.view_url, (data) =>
      @data = data
      @trigger(@data)

@Realization = React.createClass
  mixins: [
    Reflux.connect DescriptionStore, "description"
  ]

  componentDidMount: ->
    console.log "did mount"
    actStartPolling()

  render: ->
    `<div>
      <Status status={this.state.description.status}/>
      <Resources />
    </div>`

Status = React.createClass
  render: ->
    status = this.props.status
    `<div>
      <div className='row section-row'>
        <div className='col-sm-12'>
          <h4>{I18n.t('experiment_realizations.show.status')}</h4>
        </div>
      </div>
      <div className='row'>
        <div className='col-sm-12'>
          <p>{status}</p>
        </div>
      </div>
    </div>`

Resources = React.createClass
  render: -> `<div/>`

actStartPolling = Reflux.createAction()

RealizationStore = Reflux.createStore
  init: ->
    @data = gon.data
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
    Reflux.connect RealizationStore, "realization"
  ]

  componentDidMount: ->
    actStartPolling()

  render: ->
    `<div>
      <Status status={this.state.realization.description.status}/>
      <Resources resources={this.state.realization.resources} />
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
  getInitialState: ->
    { closed: true }

  toggle: ->
    @setState closed: !@state.closed

  render: ->
    if @state.closed
      title = 'Show'
      panel = `<div/>`
    else
      title = 'Hide'
      rows = this.props.resources.map (r) ->
        `<ResourceRow key={r.name} resource={r} />`

      panel = `<div className='row'>
        <div className='col-sm-12'>
          <table className='table table-striped'>
            <tbody>
              {rows}
            </tbody>
          </table>
        </div>
      </div>`

    `<div>
      <div className='row section-row'>
        <div className='col-sm-11'>
          <h4>{I18n.t('experiment_realizations.show.resource_usage')}</h4>
        </div>
        <div className='col-sm-1 text-right'>
          <button className='btn btn-xs btn-default' onClick={this.toggle}>{title}</button>
        </div>
      </div>
      {panel}
    </div>`

ResourceRow = React.createClass
  render: ->
    r = this.props.resource

    tags = r.tags.map (t) ->
      "#{t.name}=#{t.value}"

    `<tr>
      <td>{r.name}</td>
      <td className='col-sm-2'>{r.type}</td>
      <td className='col-sm-4'>{tags.join(' ')}</td>
    </tr>`

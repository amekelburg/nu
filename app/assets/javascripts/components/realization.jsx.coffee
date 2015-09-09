actStartPolling = Reflux.createAction()

RealizationStore = Reflux.createStore
  init: ->
    @data = gon.data
    @listenTo actStartPolling, @onStartPolling

  getInitialState: -> @data

  onStartPolling: ->
    @interval = setInterval(@refresh, gon.refresh_rate / 3)

  refresh: ->
    $.getJSON gon.view_url, (data) =>
      @data = data
      @trigger(@data)

@Status = React.createClass
  mixins: [
    Reflux.connect RealizationStore, "realization"
  ]

  componentDidMount: ->
    actStartPolling()

  render: ->
    status = @state.realization.description.status
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

@Resources = React.createClass
  mixins: [
    Reflux.connect RealizationStore, "realization"
  ]

  getInitialState: ->
    { closed: true }

  toggle: ->
    @setState closed: !@state.closed

  render: ->
    rows = @state.realization.resources.map (r) ->
      `<ResourceRow key={r.name} resource={r} />`

    panel = `<div className='row collapse' id='resources-section'>
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
        <div className='col-sm-12 f actions'>
          <h4>{I18n.t('experiment_realizations.show.resource_usage')}</h4>
          <a data-expanded='false' data-target='#resources-section' data-toggle='expand' href='#'>
            <IconLess />
            <IconMore />
          </a>
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

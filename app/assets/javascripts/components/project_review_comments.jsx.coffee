@ProjectReviewComments = React.createClass
  getInitialState: ->
    { comments: @props.comments }

  createComment: (body) ->
    { commenter: @props.commenter, comment: body, on: '#TBD', id: +(new Date()), saving: true }

  onNewComment: (e) ->
    comment = @createComment(e)

    newComments = @state.comments
    newComments.unshift(comment)
    @setState comments: newComments

    $.post "/pending_projects/#{this.props.project_id}/add_comment",
      { comment: comment.comment },
      (data) =>
        if data.success
          cc = @state.comments
          c  = _.find(cc, (e) -> e.id == comment.id)
          c.saving = false
          @setState comments: cc
        else
          cc = @state.comments
          @setState comments: _.reject(cc, ((e) -> e.id == comment.id) )
          bootbox.alert "<strong>Failed to save your comment.</strong><br/>Please try again later."


  render: ->
    `<div>
      <Comments comments={this.state.comments} />
      <CommentForm onNewComment={this.onNewComment} /> 
    </div>`

Comments = React.createClass
  render: ->
    comments = @props.comments

    if comments.length == 0
      rows = `<tr><td>No comments</td></tr>`
    else
      # <td className='col-sm-1 text-right'>
      #   <a href='#' className='material-icons' data-bbconfirm='Are you sure to delete this comment?'>delete</a>
      # </td>
      rows = comments.map (c) ->
        cl = if c.saving then 'saving' else ''
        `<tr key={c.on}>
          <td className={cl}><strong>{c.commenter}:</strong> {c.comment}</td>
        </tr>`

    `<table className="table table-condensed table-striped table-borderless pp-comments">
      <tbody>{rows}</tbody>
     </table>`

CommentForm = React.createClass
  getInitialState: ->
    { formCollapsed: true, newComment: '' }

  toggleForm: (e) ->
    e.preventDefault()
    @setState formCollapsed: !@state.formCollapsed

  onNewComment: (e) ->
    e.preventDefault()
    @props.onNewComment @state.newComment
    @setState newComment: '', formCollapsed: true

  onCommentChange: (e) ->
    @setState newComment: e.target.value

  render: ->
    formClassName = if @state.formCollapsed then 'row hide' else 'row'

    `<div>
      <p>
        <a href="#" onClick={this.toggleForm}>New comment</a>
      </p>
      <div className={formClassName}>
        <div className="col-sm-10">
          <input type="text" ref="comment" value={this.state.newComment} onChange={this.onCommentChange} className="form-control" />
        </div>
        <div className="col-sm-2">
          <input type="submit" value="New comment" className="btn btn-default" onClick={this.onNewComment} />
        </div>
      </div>
    </div>`

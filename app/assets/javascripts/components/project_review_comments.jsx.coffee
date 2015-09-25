# - if comments.blank?
#   %tr
#     %td= t ".no_comments"
# - else
#   = render partial: 'comment_row', collection: comments
# %p= link_to t(".new_comment"), "#"
# #new-comment.f
#   .f1
#     = text_field_tag "body"
#     = submit_tag "Add"

@ProjectReviewComments = React.createClass
  getInitialState: ->
    { comments: @props.comments }

  createComment: (body) ->
    { commenter: @props.commenter, comment: body, on: '#TBD' }

  onNewComment: (e) ->
    newComments = @state.comments
    newComments.unshift(@createComment(e))

    @setState comments: newComments

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
      rows = comments.map (c) -> `<tr><td className="col-sm-1">{c.commenter}:</td><td>{c.comment}</td></tr>`

    `<table className="table table-condensed table-striped table-borderless">
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
        <div className="col-sm-6">
          <input type="text" ref="comment" value={this.state.newComment} onChange={this.onCommentChange} className="form-control" />
        </div>
        <div className="col-sm-2">
          <input type="submit" value="New comment" className="btn btn-default" onClick={this.onNewComment} />
        </div>
      </div>
    </div>`

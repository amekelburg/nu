class PendingProjectsController < ApplicationController

  before_filter :require_login

  def index
    # Get all projects visible to this user
    projects = DeterLab.view_projects(current_user_id, nil)
    @unapproved = projects.select { |p| !p.approved }
  end

end

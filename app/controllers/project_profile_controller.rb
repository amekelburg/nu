class ProjectProfileController < ApplicationController

  before_filter :require_login

  # shows the profile edit form
  def edit
    @profile_description = deter_lab.get_project_profile_description
    @profile = deter_lab.get_project_profile(params[:project_id])
  end

end

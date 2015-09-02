class DashboardController < ApplicationController

  before_filter :require_login

  # shows user dashboard
  def show
    gon.resourcesUrl = resources_dashboard_url
  end

  # resources details
  def resources
    @resources = DashboardResources.new(current_user_id, deter_lab)
    render :resources, layout: false
  end

end

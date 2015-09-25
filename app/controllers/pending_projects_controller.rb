class PendingProjectsController < ApplicationController

  before_filter :require_login

  # lists all pending projects
  def index
    # Get all projects visible to this user
    projects = DeterLab.view_projects(current_user_id, nil)
    @unapproved = projects.select { |p| !p.approved && !RejectedProjects.include?(p.project_id) }

    @activity_records = ProjectApprovalLog.records
  end

  # attempts to approve the project
  def approve
    DeterLab.approve_project(current_user_id, params[:id])
    RejectedProjects.remove(params[:id])
    ProjectApprovalLog.record_approval(current_user_id, params[:id])
    deter_lab.invalidate_projects
    redirect_to :pending_projects, notice: t('.success')
  rescue DeterLab::RequestError
    redirect_to :pending_projects, alert: t('.failure')
  end

  # attempts to reject the project
  def reject
    safe_reject
    ProjectApprovalLog.record_rejection(current_user_id, params[:id])
    deter_lab.invalidate_projects
    redirect_to :pending_projects, notice: t('.success')
  rescue DeterLab::RequestError
    redirect_to :pending_projects, alert: t('.failure')
  end

  private

  def safe_reject
    projects = DeterLab.view_projects(current_user_id, nil)
    project  = projects.find { |p| p.project_id == params[:id] }
    if !project.approved
      RejectedProjects.add(params[:id])
    else
      raise DeterLab::RequestError.new('Project not found')
    end
  end

end

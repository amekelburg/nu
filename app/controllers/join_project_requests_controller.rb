class JoinProjectRequestsController < ApplicationController

  before_filter :require_login

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to :join_project_requests, alert: t('join_project_requests.not_found')
  end

  def approve
    if DeterLab.join_project_confirm(current_user_id, notification.challenge)
      JoinRequestsManager.mark_as_approved!(notification.id)
      redirect_to :join_project_requests, notice: t('.success')
    else
      redirect_to :join_project_requests, alert: t('.failure')
    end
  end

  def reject
    DeterLab.join_project_reject(current_user_id, notification.challenge)
    JoinRequestsManager.mark_as_rejected!(notification.id)
    redirect_to :join_project_requests, notice: t('.success')
  end

  private

  def notification
    @n ||= @notifications.find { |n| n.id == params[:id] } or raise ActiveRecord::RecordNotFound
  end

end

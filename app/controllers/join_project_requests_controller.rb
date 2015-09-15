class JoinProjectRequestsController < ApplicationController

  before_filter :require_login

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to :join_project_requests, alert: t('join_project_requests.not_found')
  end

  def approve
    DeterLab.join_project_confirm(current_user_id, notification.challenge)
    JoinRequestsManager.mark_as_approved!(notification.id)
    redirect_to :join_project_requests, notice: t('.success')
  rescue DeterLab::Error => e
    redirect_to :join_project_requests, alert: t('.failure', error: e.message)
  end

  def reject
    # There's no SPI action for this
    # DeterLab.join_project_reject(current_user_id, notification.challenge)
    JoinRequestsManager.mark_as_rejected!(notification.id)
    redirect_to :join_project_requests, notice: t('.success')
  end

  private

  def notification
    @n ||= @notifications.find { |n| n.id == params[:id] } or raise ActiveRecord::RecordNotFound
  end

end

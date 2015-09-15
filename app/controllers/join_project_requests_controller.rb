class JoinProjectRequestsController < ApplicationController

  before_filter :require_login

  def show
    @req = @notifications.find { |n| n.id == params[:id] }
  end

end

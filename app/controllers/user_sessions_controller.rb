class UserSessionsController < ApplicationController

  before_filter :require_login, only: [ :destroy ]

  class UserLogin < Hashie::Dash
    property :username
    property :password

    def initialize(p = nil)
      super p
      self.username = self.username.try(:downcase)
    end

    def valid?
      self.username.present? && self.password.present? && DeterLab.valid_credentials?(self.username, self.password)
    end
  end

  # New login form
  def new
    @login = UserLogin.new
  end

  # Logs the user in
  def create
    @login = UserLogin.new(user_login_params)

    if @login.valid?
      admin = DeterLab.admin?(@login.username)

      ActivityLog.for_user(@login.username).add(:login, @login.username)

      app_session.logged_in_as(@login.username, admin)
      current_user_session.register_login

      redirect_to :dashboard, notice: t(".success")
    else
      @error = true
      @login.password = nil
      render :new
    end
  end

  # Logs the user out
  def destroy
    user_id = app_session.current_user_id
    current_user_session.register_logout

    app_session.logged_out
    DeterLab.logout(user_id)
    SslKeyStorage.delete(user_id)

    ActivityLog.for_user(user_id).add(:logout, user_id)
  rescue DeterLab::NotLoggedIn
    # That's ok. We are logging out anyway
  ensure
    redirect_to :login, notice: t(".success")
  end

  private

  def user_login_params
    params[:user_login].permit(:username, :password).symbolize_keys
  end
end

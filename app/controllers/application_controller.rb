class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :init_gon
  before_action :change_locale
  before_action :preload_data

  # No connection to backend
  rescue_from SocketError do |e|
    log_backend_error 'no_connection', e
  end

  # General DETER error
  rescue_from DeterLab::Error do |e|
    if e.is_a? DeterLab::NotLoggedIn
      app_session.logged_out
      redirect_to :login
    else
      log_backend_error 'deter_error', e
    end
  end

  # Application session wrapper
  def app_session
    @app_session ||= AppSession.new(session)
  end
  helper_method :app_session

  # Returns TRUE if logged in
  def logged_in?
    app_session.logged_in?
  end
  helper_method :logged_in?

  def require_login
    if app_session.logged_in?
      true
    else
      redirect_to :login
    end
  end

  # returns true if the user is in the admin project circle
  def admin?
    app_session.admin?
  end
  helper_method :admin?

  # Returns the instance of cache configured for the current user
  def deter_cache
    @deter_cache ||= DeterCache.new(current_user_id)
  end

  # returns the cached deter lab access layer
  def deter_lab
    @deter_lab ||= CachedDeterLab.new(deter_cache, current_user_id)
  end
  helper_method :deter_lab

  # returns the user name
  def user_name(uid)
    deter_lab.get_profile(uid).try(:[], "name")
  end
  helper_method :user_name

  # returns the user name
  def current_user_name
    logged_in? ? (user_name(current_user_id) || current_user_id) : nil
  end
  helper_method :current_user_name

  # returns currently logged in user id
  def current_user_id
    app_session.current_user_id
  end
  helper_method :current_user_id

  # returns currently logged in user session
  def current_user_session
    @current_user_session ||= UserSession.new(current_user_id)
  end
  helper_method :current_user_session

  private

  def init_gon
    gon.controller = params[:controller]
    gon.action = params[:action]
  end

  def change_locale
    if l = params[:locale]
      session[:locale] = l
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end

  def preload_data
    if logged_in?
      @notifications = Rails.env.test? ? [] : deter_lab.get_notifications rescue []
    end
  end

  def log_backend_error(type, e)
    @e = e

    details = e.backtrace.keep_if { |p| p =~ %r{/app/} }.join("\n")
    logger.error "----------\nBackend Service Error\n#{e}\n#{details}\n----------"

    render "errors/#{type}"
  end

end

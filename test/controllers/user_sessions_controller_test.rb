require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  test "shows login page" do
    get :new
    assert_select 'h1', 'Welcome to DeterLab'
  end

  test "logs in as a user" do
    DeterLab.stubs(:valid_credentials?).returns(true)
    DeterLab.stubs(:admin?).returns(false)
    @app_session = AppSession.new(@controller.session)

    post :create, user_login: { username: 'user_id', password: 'pass' }
    assert_redirected_to :dashboard
    assert @app_session.logged_in?
    assert !@app_session.admin?
  end

  test "doesn't login" do
    DeterLab.stubs(:valid_credentials?).returns(false)

    post :create, user_login: { username: 'user_id', password: 'pass' }
    assert_template :new
    assert assigns(:error)
  end

  test "logging out" do
    DeterLab.stubs(:logout).returns(true)

    @app_session = AppSession.new(@controller.session)

    delete :destroy
    assert_equal I18n.t("user_sessions.destroy.success"), flash.notice
    assert_redirected_to :login

    assert !@app_session.logged_in?
  end

  test "logging out when session is lost" do
    DeterLab.expects(:logout).raises(DeterLab::NotLoggedIn)

    @app_session = AppSession.new(@controller.session)

    delete :destroy
    assert_redirected_to :login

    assert !@app_session.logged_in?
  end
end

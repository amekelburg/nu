require 'test_helper'

class JoinProjectRequestsControllerTest < ActionController::TestCase

  setup do
    @challenge  = "0123456789"
    @requester  = "janedoe"
    @project_id = "ProjectOne"
    body = "#{@requester} has asked to join your project #{@project_id} challenge #{@challenge}"
    @n = Notification.new('nid', body, [], true)

    @controller.stubs(:notification).returns(@n)
  end

  test "index" do
    get :index
  end

  test "successful approval" do
    DeterLab.expects(:join_project_confirm).with('mark', @n.challenge).returns(true)
    JoinRequestsManager.expects(:mark_as_approved!).with(@n.id)

    post :approve, id: @n.id

    assert_redirected_to :join_project_requests
    assert_equal I18n.t("join_project_requests.approve.success"), flash.notice
  end

  test "approving missing request" do
    @controller.stubs(:notification).raises(ActiveRecord::RecordNotFound)
    post :approve, id: 'missing'

    assert_redirected_to :join_project_requests
    assert_equal I18n.t("join_project_requests.not_found"), flash.alert
  end

  test "failed approval" do
    DeterLab.expects(:join_project_confirm).raises(DeterLab::Error.new('error'))
    JoinRequestsManager.expects(:mark_as_approved!).never

    post :approve, id: @n.id

    assert_redirected_to :join_project_requests
    assert_equal I18n.t("join_project_requests.approve.failure", error: 'error'), flash.alert
  end

  test "successful rejection" do
    # DeterLab.expects(:join_project_reject).with('mark', @n.challenge)
    JoinRequestsManager.expects(:mark_as_rejected!).with(@n.id)

    post :reject, id: @n.id

    assert_redirected_to :join_project_requests
    assert_equal I18n.t("join_project_requests.reject.success"), flash.notice
  end

  test "rejecting missing request" do
    @controller.stubs(:notification).raises(ActiveRecord::RecordNotFound)
    post :reject, id: 'missing'

    assert_redirected_to :join_project_requests
    assert_equal I18n.t("join_project_requests.not_found"), flash.alert
  end

end

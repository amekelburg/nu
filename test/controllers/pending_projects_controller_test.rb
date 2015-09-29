require 'test_helper'

class PendingProjectsControllerTest < ActionController::TestCase

  test '#index' do
    DeterLab.expects(:view_projects).returns([])
    ProjectApprovalLog.expects(:records).returns([])
    get :index
    assert_template :index
  end

  test '#approve error' do
    DeterLab.expects(:approve_project).raises(DeterLab::RequestError)
    post :approve, id: 'missing'
    assert_redirected_to :pending_projects
    assert_equal I18n.t('pending_projects.approve.failure'), flash.alert
  end

  test '#approve success' do
    DeterLab.expects(:approve_project).with('mark', 'pending_project')
    ProjectApprovalLog.expects(:record_approval).with('mark', 'pending_project')
    @controller.deter_lab.expects(:invalidate_projects)
    post :approve, id: 'pending_project'
    assert_redirected_to :pending_projects
    assert_equal I18n.t('pending_projects.approve.success'), flash.notice
  end

  test '#reject error' do
    @controller.expects(:safe_reject).raises(DeterLab::RequestError)
    post :reject, id: 'missing'
    assert_redirected_to :pending_projects
    assert_equal I18n.t('pending_projects.reject.failure'), flash.alert
  end

  test '#reject success' do
    @controller.expects(:safe_reject)
    ProjectApprovalLog.expects(:record_rejection).with('mark', 'pending_project')
    @controller.deter_lab.expects(:invalidate_projects)
    post :reject, id: 'pending_project'
    assert_redirected_to :pending_projects
    assert_equal I18n.t('pending_projects.reject.success'), flash.notice
  end

  test "#add_comment success" do
    pid = 'pid'
    comment = 'hello'
    @controller.expects(:safe_project).returns(:project)
    ProjectReviewComments.expects(:add).with(pid, 'mark', comment)
    post :add_comment, id: pid, comment: comment, format: 'json'
    assert_equal({ success: true }.to_json, @response.body)
  end

  test "#add_comment no access to project" do
    pid = 'pid'
    @controller.expects(:safe_project).returns(nil)
    ProjectReviewComments.expects(:add).never
    post :add_comment, id: pid, comment: '', format: 'json'
    assert_equal({ success: false }.to_json, @response.body)
  end

end

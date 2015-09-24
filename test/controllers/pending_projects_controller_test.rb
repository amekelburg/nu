require 'test_helper'

class PendingProjectsControllerTest < ActionController::TestCase

  test '#index' do
    DeterLab.expects(:view_projects).returns([])
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
    DeterLab.expects(:remove_project).raises(DeterLab::RequestError)
    post :reject, id: 'missing'
    assert_redirected_to :pending_projects
    assert_equal I18n.t('pending_projects.reject.failure'), flash.alert
  end

  test '#reject success' do
    DeterLab.expects(:remove_project).with('mark', 'pending_project')
    ProjectApprovalLog.expects(:record_rejection).with('mark', 'pending_project')
    @controller.deter_lab.expects(:invalidate_projects)
    post :reject, id: 'pending_project'
    assert_redirected_to :pending_projects
    assert_equal I18n.t('pending_projects.reject.success'), flash.notice
  end

end

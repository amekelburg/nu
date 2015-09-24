require 'test_helper'

class ProjectApprovalLogTest < ActiveSupport::TestCase

  setup do
    ProjectApprovalLog.clear
  end

  test 'recording approval' do
    moment = Time.now
    ProjectApprovalLog.record_approval('mark', 'project', moment)
    assert_equal [ { reviewer: 'mark', action: 'approve', project_id: 'project', on: moment } ], ProjectApprovalLog.records
  end

  test 'recording rejection' do
    moment = Time.now
    ProjectApprovalLog.record_rejection('mark', 'project', moment)
    assert_equal [ { reviewer: 'mark', action: 'reject', project_id: 'project', on: moment } ], ProjectApprovalLog.records
  end

end

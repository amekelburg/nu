require 'test_helper'

class JoinRequestsManagerTest < ActiveSupport::TestCase

  test "approved? for new request" do
    refute JoinRequestsManager.approved?('new')
  end

  test "rejected? for new request" do
    refute JoinRequestsManager.rejected?('new')
  end

  test "mark_as_approved!" do
    JoinRequestsManager.mark_as_approved! 'test-req-app'
    assert JoinRequestsManager.approved?('test-req-app')
    refute JoinRequestsManager.rejected?('test-req-app')
  end

  test "mark_as_rejected!" do
    JoinRequestsManager.mark_as_rejected! 'test-req-rej'
    refute JoinRequestsManager.approved?('test-req-rej')
    assert JoinRequestsManager.rejected?('test-req-rej')
  end

end

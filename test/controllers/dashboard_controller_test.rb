require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "blocking non-logged users" do
    logout
    get :show
    assert_redirected_to :login
  end

  test "rendering for logged in users" do
    @controller.deter_lab.stubs(:get_managed_projects).returns([])
    @controller.deter_lab.stubs(:get_profile).returns('name' => 'Mark Smith')

    get :show
    assert_response :success
  end

end


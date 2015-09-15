require 'test_helper'

class CirclesControllerTest < ActionController::TestCase

  test "listing circles" do
    get :index
    assert_not_nil assigns[:circles]
  end

end

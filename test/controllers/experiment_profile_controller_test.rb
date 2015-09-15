require 'test_helper'

class ExperimentProfileControllerTest < ActionController::TestCase

  test 'should show the form' do
    SummaryLoader.stubs(:user_managed_experiments).returns([])
    @controller.deter_lab.expects(:get_experiment_profile_description).returns([])
    @controller.deter_lab.expects(:get_experiment_profile).returns([])
    get :edit, experiment_id: 'Project:Experiment'
    assert_template :edit
    assert_not_nil assigns[:profile]
    assert_not_nil assigns[:profile_description]
  end

end

require 'test_helper'

class ProjectJoinsTest < ActiveSupport::TestCase

  setup do
    ProjectJoins.reset
  end

  test 'initial state' do
    assert_equal [], ProjectJoins.list_projects('user_id')
  end

  test 'add project' do
    ProjectJoins.add_project('user_id', 'project_id')
    assert_equal [ 'project_id' ], ProjectJoins.list_projects('user_id')
    assert_equal [], ProjectJoins.list_projects('other_user_id')
  end

  test 'remove project' do
    ProjectJoins.add_project('user_id', 'project_id')
    ProjectJoins.add_project('user_id', 'project_id_2')
    ProjectJoins.remove_project('user_id', 'project_id')
    assert_equal [ 'project_id_2' ], ProjectJoins.list_projects('user_id')
  end
end

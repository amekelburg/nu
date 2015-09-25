require 'test_helper'

class RejectedProjectsTest < ActiveSupport::TestCase

  setup do
    RejectedProjects.clear
  end

  test "adding projects" do
    refute RejectedProjects.include?('pid')
    RejectedProjects.add('pid')
    assert RejectedProjects.include?('pid')
  end

  test "removing projects" do
    RejectedProjects.add('pid')
    RejectedProjects.remove('pid')
    refute RejectedProjects.include?('pid')
  end

end

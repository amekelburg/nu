require 'test_helper'

class ProjectReviewCommentsTest < ActiveSupport::TestCase

  setup do
    ProjectReviewComments.clear
  end

  test 'add comment' do
    now = Time.now
    later = 1.minute.from_now

    ProjectReviewComments.add('pid1', 'mark', '1', now)
    ProjectReviewComments.add('pid1', 'mark', '2', later)
    ProjectReviewComments.add('pid2', 'mark', '3', now)

    assert_equal [], ProjectReviewComments.comments('pid-no-comments')
    assert_equal [ { commenter: 'mark', comment: '2', on: later },
                   { commenter: 'mark', comment: '1', on: now } ],
                 ProjectReviewComments.comments('pid1')
  end

end

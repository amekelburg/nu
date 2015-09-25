class ProjectReviewComments

  def self.clear
    keys.each { |k| REDIS.del(k) }
  end

  def self.add(pid, commenter, comment, moment = Time.now)
    REDIS.lpush "project_review_comments:#{pid}", {
      commenter: commenter, comment: comment, on: moment }.to_yaml
  end

  def self.comments(pid)
    items = REDIS.lrange("project_review_comments:#{pid}", 0, -1) || []
    items.map { |i| YAML::load(i) }
  end

  private

  def self.keys
    REDIS.keys "project_review_comments:*"
  end

end

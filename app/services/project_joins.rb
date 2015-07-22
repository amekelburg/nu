class ProjectJoins

  # reset the registry
  def self.reset
    keys = REDIS.keys "project_joins:*"
    REDIS.del keys if keys.any?
  end

  # registers
  def self.add_project(user_id, project_id)
    REDIS.sadd "project_joins:#{user_id}", project_id
  end

  # removes registration record for user joining project
  def self.remove_project(user_id, project_id)
    REDIS.srem "project_joins:#{user_id}", project_id
  end

  # returns the list of project IDs requested by user
  def self.list_projects(user_id)
    list = REDIS.smembers "project_joins:#{user_id}"
    list || []
  end

end

# Temporary services for recording of rejected projects
class RejectedProjects

  KEY = "deter:rejected_projects"

  def self.add(pid)
    REDIS.sadd KEY, pid
  end

  def self.remove(pid)
    REDIS.srem KEY, pid
  end

  def self.clear
    REDIS.del KEY
  end

  def self.include?(pid)
    REDIS.sismember(KEY, pid)
  end

end

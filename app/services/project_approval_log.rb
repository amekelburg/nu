class ProjectApprovalLog

  def self.record_approval(reviewer, project_id, moment = Time.now)
    add_record reviewer, 'approve', project_id, moment
  end

  def self.record_rejection(reviewer, project_id, moment = Time.now)
    add_record reviewer, 'reject', project_id, moment
  end

  def self.records
    keys = REDIS.keys "deter:project_approval_log:*"
    keys.sort { |a, b| b <=> a }.map { |k| YAML::load(REDIS.get(k)) }
  end

  def self.clear
    keys = REDIS.keys "deter:project_approval_log:*"
    REDIS.del keys.join(' ')
  end

  private

  def self.add_record(reviewer, action, project_id, moment)
    rec = {
      reviewer: reviewer,
      action: action,
      project_id: project_id,
      on: moment
    }

    ts = moment.strftime("%Y%m%d%H%M%S%L")

    REDIS.setex "deter:project_approval_log:#{ts}", max_days.days, rec.to_yaml
  end

  def self.max_days
    AppConfig['project_approval_log']['days_max']
  end

end

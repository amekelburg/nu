class JoinRequestsManager

  def self.approved?(req_id)
    REDIS.hget('project_join_request_status', req_id) == 'approved'
  end

  def self.rejected?(req_id)
    REDIS.hget('project_join_request_status', req_id) == 'rejected'
  end

  def self.processed?(req_id)
    !REDIS.hget('project_join_request_status', req_id).blank?
  end

  def self.mark_as_approved!(req_id)
    REDIS.hset 'project_join_request_status', req_id, 'approved'
  end

  def self.mark_as_rejected!(req_id)
    REDIS.hset 'project_join_request_status', req_id, 'rejected'
  end

end

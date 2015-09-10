class DashboardResources

  def initialize(uid, deter_lab)
    @uid = uid
    @d = deter_lab
  end

  def experiments
    @d.get_experiments
  end

  def project_experiments
    @d.get_experiments.select { |e| e.id =~ /^[A-Z]/ }
  end

  def libraries_experiments
    @d.get_experiments.select { |e| e.id =~ /^[a-z]/ }
  end

  def accessible_experiments_count
    project_experiments.count
  end

  def member_of_projects_count
    @d.get_projects.count
  end

  def running_experiment_ids
    all_realizations.select { |r| r.status == 'Active' }.map(&:experiment).uniq.sort
  end

  def total_realizations
    all_realizations.size
  end

  def all_realizations
    unless defined? @realizations
      @realizations = DeterLab.view_realizations(@uid)
    end
    @realizations
  end

  def projects
    @d.get_projects.sort do |p1, p2|
      p1o = p1.owner == @uid
      p2o = p2.owner == @uid

      if p1o == p2o
        p1.project_id <=> p2.project_id
      elsif p1o
        -1
      else
        1
      end
    end
  end

  def owned_project_ids
    @d.get_projects.select { |p| p.owner == @uid }.map(&:project_id)
  end

  def joined_project_ids
    @d.get_projects.select { |p| p.owner != @uid }.map(&:project_id)
  end

  def accessible_library_experiments
    @d.get_experiments.select { |e| e.id !~ /^[A-Z]/ }
  end

  def libraries
    @d.view_libraries
  end

  #
  # Notifications
  #

  def notifications
    @notifications ||= DeterLab.get_notifications(@uid)
  end

  def unread_notifications
    notifications.count { |n| !n.read? }
  end

  def total_notifications
    notifications.size
  end

  def unread_project_requests_count
    notifications.count { |n| n.new_project_request? && !n.read? }
  end

  def new_project_notifications_count
    @d.get_projects.count { |p| !p[:approved] }
  end

  def join_project_notifications_count
    ProjectJoins.list_projects(@uid).size
  end

end

class Library < Struct.new(:id, :owner, :perms, :experiments, :members)

  ADD_EXPERIMENT        = "ADD_EXPERIMENT"
  REMOVE_EXPERIMENT     = "REMOVE_EXPERIMENT"
  READ_LIBRARY          = "READ_LIBRARY"
  MODIFY_LIBRARY_ACCESS = "MODIFY_LIBRARY_ACCESS"

  MAIN_LIBRARY_ID       = AppConfig['main_library_id']
  MAIN_LIBRARY_NAME     = 'Main Library'

  def can_add_experiment?(uid)
    [ self.perms ].flatten.include?(ADD_EXPERIMENT)
  end

end

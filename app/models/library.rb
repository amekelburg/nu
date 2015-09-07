class Library < Struct.new(:id, :owner, :perms, :experiments, :members)
  MAIN_LIBRARY_ID   = AppConfig['main_library_id']
  MAIN_LIBRARY_NAME = 'Main Library'
end

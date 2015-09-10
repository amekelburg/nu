if Rails.env.test?
  TestsConfig = load_config('tests-config.yml')
end

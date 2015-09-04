role :app, %w{alg@noizeramp.com}
role :web, %w{alg@noizeramp.com}
role :db,  %w{alg@noizeramp.com}

set :deploy_to, '/home/alg/sites/deter-gdocs.noizeramp.com'
set :rails_env, 'production'
set :branch,    'deter-gdocs'

set :rvm_ruby_version, '2.1.3'

require 'mina/bundler'
require 'mina/rails'

namespace :unicorn do
  set_default :unicorn_role,      -> { user }
  set_default :unicorn_env,       -> { fetch(:rails_env, 'production') }
  set_default :unicorn_config,    -> { "#{deploy_to}/#{current_path}/config/unicorn.rb" }
  set_default :unicorn_pid,       -> { "#{deploy_to}/#{current_path}/tmp/pids/unicorn.pid"  }
  set_default :unicorn_cmd,       -> { "#{bundle_prefix} unicorn" }

  desc "Start unicorn service"
  task :start => :environment do
    queue %{
      echo "-----> Starting unicorn service"
      #{echo_cmd %[cd #{deploy_to}/#{current_path}; #{unicorn_cmd} -c #{unicorn_config} -D -E #{unicorn_env}]}
    }
  end

  desc "Stop unicorn service"
  task :stop => :environment do
    queue %{
      echo "-----> Stoping unicorn service"
      #{echo_cmd %[kill -s QUIT `cat #{unicorn_pid}`]}
    }
  end

  desc "Restart unicorn service"
  task :restart => :environment do
    queue %{
      echo "-----> Restart unicorn service"
      #{echo_cmd %[kill -s USR2 `cat #{unicorn_pid}`]}
    }
  end
end


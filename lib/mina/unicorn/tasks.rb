require 'mina/bundler'
require 'mina/rails'
require 'mina/unicorn/utility'

namespace :unicorn do
  include Mina::Unicorn::Utility

  set_default :unicorn_role,      -> { user }
  set_default :unicorn_env,       -> { fetch(:rails_env, 'production') }
  set_default :unicorn_config,    -> { "#{deploy_to}/#{current_path}/config/unicorn.rb" }
  set_default :unicorn_pid,       -> { "#{deploy_to}/#{current_path}/tmp/pids/unicorn.pid"  }
  set_default :unicorn_cmd,       -> { "#{bundle_prefix} unicorn" }
  set_default :unicorn_restart_sleep_time, -> { 2 }
  set_default :bundle_gemfile,    -> { "#{deploy_to}/#{current_path}/Gemfile" }

  desc "Start Unicorn master process"
  task start: :environment do
    queue start_unicorn
  end

  desc "Stop Unicorn"
  task stop: :environment do
    queue kill_unicorn('QUIT')
  end

  desc "Immediately shutdown Unicorn"
  task shutdown: :environment do
    queue kill_unicorn('TERM')
  end

  desc "Restart unicorn service"
  task restart: :environment do
    queue restart_unicorn
  end
end


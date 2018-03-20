require "mina/bundler"
require "mina/deploy"
require "mina/unicorn/utility"

namespace :unicorn do
  include Mina::Unicorn::Utility

  set :unicorn_env,       -> { fetch(:rails_env) || fetch(:rack_env) || "deployment" }
  set :unicorn_config,    -> { "#{fetch(:current_path)}/config/unicorn.rb" }
  set :unicorn_pid,       -> { "#{fetch(:current_path)}/tmp/pids/unicorn.pid" }
  set :unicorn_cmd,       -> { "#{fetch(:bundle_prefix, "#{fetch(:bundle_bin)} exec")} unicorn" }
  set :unicorn_restart_sleep_time, -> { 2 }
  set :bundle_gemfile,    -> { "#{fetch(:current_path)}/Gemfile" }

  desc "Start Unicorn master process"
  task :start do
    command start_unicorn
  end

  desc "Stop Unicorn"
  task :stop do
    command kill_unicorn("QUIT")
  end

  desc "Immediately shutdown Unicorn"
  task :shutdown do
    command kill_unicorn("TERM")
  end

  desc "Restart unicorn service"
  task restart: :remote_environment do
    command restart_unicorn
  end
end

require "mina/bundler"
require "mina/deploy"
require "mina/unicorn/utility"

namespace :unicorn do
  include Mina::Unicorn::Utility

  # Following recommendations from http://unicorn.bogomips.org/unicorn_1.html#rack-environment
  set :unicorn_env,       -> { fetch(:rails_env) == "development" ? "development" : "deployment" }
  set :unicorn_config,    -> { "#{fetch(:current_path)}/config/unicorn.rb" }
  set :unicorn_pid,       -> { "#{fetch(:current_path)}/tmp/pids/unicorn.pid" }
  set :unicorn_cmd,       -> { "#{fetch(:bundle_prefix, "#{fetch(:bundle_bin)} exec")} unicorn" }
  set :unicorn_restart_sleep_time, -> { 2 }
  set :bundle_gemfile,    -> { "#{fetch(:current_path)}/Gemfile" }

  desc "Start Unicorn master process"
  task start: :remote_environment do
    command start_unicorn
  end

  desc "Stop Unicorn"
  task stop: :remote_environment do
    command kill_unicorn("QUIT")
  end

  desc "Immediately shutdown Unicorn"
  task shutdown: :remote_environment do
    command kill_unicorn("TERM")
  end

  desc "Restart unicorn service"
  task restart: :remote_environment do
    command restart_unicorn
  end

  desc "Tail error log from server"
  task :error_log, [:fname] => :environment do |_, args|
    queue %[tail -f #{deploy_to}/#{current_path}/log/#{args.nil? ? 'unicorn.stderr.log' : args[:fname]}]
  end

  desc "Tail access log from server"
  task :access_log, [:fname] => :environment do |_, args|
    queue %[tail -f #{deploy_to}/#{current_path}/log/#{args.nil? ? 'unicorn.stdout.log' : args[:fname]}]
  end

end

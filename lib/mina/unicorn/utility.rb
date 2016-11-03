# Ported from: https://github.com/sosedoff/capistrano-unicorn/blob/master/lib/capistrano-unicorn/utility.rb

module Mina
  module Unicorn
    module Utility
      def start_unicorn
        %{
          if [ -e "#{unicorn_pid}" ]; then
            if #{unicorn_user} kill -0 `cat #{unicorn_pid}` > /dev/null 2>&1; then
              echo "-----> Unicorn is already running!";
              exit 0;
            fi;

            #{unicorn_user} rm #{unicorn_pid};
          fi;

          echo "-----> Starting Unicorn...";
          cd #{fetch(:current_path)} && #{unicorn_user} BUNDLE_GEMFILE=#{fetch(:bundle_gemfile)} #{fetch(:unicorn_cmd)} -c #{fetch(:unicorn_config)} -E #{fetch(:unicorn_env)} -D
        }
      end

      def kill_unicorn(signal)
        %{
          if #{unicorn_is_running?}; then
            echo "-----> Stopping Unicorn...";
            #{unicorn_send_signal(signal)};
          else
            echo "-----> Unicorn is not running.";
          fi
        }
      end

      def restart_unicorn
        %{
          #{duplicate_unicorn}

          sleep #{fetch(:unicorn_restart_sleep_time)}; # in order to wait for the (old) pidfile to show up

          if #{old_unicorn_is_running?}; then
            #{unicorn_send_signal("QUIT", get_old_unicorn_pid)};
          fi
        }
      end

      # Send a signal to a unicorn master processes
      def unicorn_send_signal(signal, pid=get_unicorn_pid)
        "#{unicorn_user} kill -s #{signal} #{pid}"
      end

      private

      # Run a command as the :unicorn_user user if :unicorn_user is set
      # Otherwise run without sudo
      def unicorn_user
        "sudo -u #{fetch(:unicorn_user)}" if set?(:unicorn_user)
      end

      # Check if a remote process exists using its pid file
      #
      def remote_process_exists?(pid_file)
        "[ -e #{pid_file} ] && #{unicorn_user} kill -0 `cat #{pid_file}` > /dev/null 2>&1"
      end

      def duplicate_unicorn
        %{
          if #{unicorn_is_running?}; then
            echo "-----> Duplicating Unicorn...";
            #{unicorn_send_signal("USR2")};
          else
            #{start_unicorn}
          fi
        }
      end

      # Command to check if Unicorn is running
      #
      def unicorn_is_running?
        remote_process_exists?(unicorn_pid)
      end

      # Command to check if stale Unicorn is running
      #
      def old_unicorn_is_running?
        remote_process_exists?(old_unicorn_pid)
      end

      def unicorn_pid
        fetch(:unicorn_pid)
      end

      # Stale Unicorn process pid file
      def old_unicorn_pid
        "#{unicorn_pid}.oldbin"
      end

      # Get unicorn master (old) process PID
      def get_old_unicorn_pid
        get_unicorn_pid(old_unicorn_pid)
      end

      # Get unicorn master process PID (using the shell)
      def get_unicorn_pid(pid_file=unicorn_pid)
        "`cat #{pid_file}`"
      end
    end
  end
end

# Ported from: https://github.com/sosedoff/capistrano-unicorn/blob/master/lib/capistrano-unicorn/utility.rb

module Mina
  module Unicorn
    module Utility

      # Check if a remote process exists using its pid file
      #
      def remote_process_exists?(pid_file)
        "[ -e #{pid_file} ] && kill -0 `cat #{pid_file}` > /dev/null 2>&1"
      end

      # Stale Unicorn process pid file
      #
      def old_unicorn_pid
        "#{unicorn_pid}.oldbin"
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

      # Get unicorn master process PID (using the shell)
      #
      def get_unicorn_pid(pid_file=unicorn_pid)
        "`cat #{pid_file}`"
      end

      # Get unicorn master (old) process PID
      #
      def get_old_unicorn_pid
        get_unicorn_pid(old_unicorn_pid)
      end

      # Send a signal to a unicorn master processes
      #
      def unicorn_send_signal(signal, pid=get_unicorn_pid)
        "kill -s #{signal} #{pid}"
      end

      # Kill Unicorns in multiple ways O_O
      #
      def kill_unicorn(signal)
        script = <<-END
          if #{unicorn_is_running?}; then
            echo "-----> Stopping Unicorn...";
            #{unicorn_send_signal(signal)};
          else
            echo "-----> Unicorn is not running.";
          fi;
        END

        script
      end

      # Start the Unicorn server
      #
      def start_unicorn
        %Q%
          if [ -e "#{unicorn_pid}" ]; then
            if kill -0 `cat #{unicorn_pid}` > /dev/null 2>&1; then
              echo "-----> Unicorn is already running!";
              exit 0;
            fi;

            rm #{unicorn_pid};
          fi;

          echo "-----> Starting Unicorn...";
          cd #{deploy_to}/#{current_path} && BUNDLE_GEMFILE=#{bundle_gemfile} #{unicorn_cmd} -c #{unicorn_config} -E #{unicorn_env} -D;
        %
      end

      # Restart the Unicorn server
      #
      def restart_unicorn
        %Q%
          #{duplicate_unicorn}

          sleep #{unicorn_restart_sleep_time}; # in order to wait for the (old) pidfile to show up

          if #{old_unicorn_is_running?}; then
            #{unicorn_send_signal('QUIT', get_old_unicorn_pid)};
          fi;
        %
      end

      def duplicate_unicorn
        %Q%
          if #{unicorn_is_running?}; then
            echo "-----> Duplicating Unicorn...";
            #{unicorn_send_signal('USR2')};
          else
            #{start_unicorn}
          fi;
        %
      end

    end
  end
end

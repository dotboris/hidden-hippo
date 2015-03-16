require 'hidden_hippo/paths'

module HiddenHippo
  class Daemon
    include HiddenHippo::Paths

    def initialize(name)
      @name = name
    end

    def start
      if running?
        puts "#{@name} is already running"
        puts "If this is not the case, delete #{pid_file}"
        exit 1
      else
        if stale_pid_file?
          puts 'Found a stale pid file, removing it'
          pid_file.delete
        end

        pid_file.dirname.mkpath
        log_file.dirname.mkpath

        pid = run

        File.write pid_file, pid

        puts "Started #{@name} service"
      end
    end

    def stop
      if pid_file.exist?
        pid = pid_file.read.to_i
        Process.kill 15, pid
        pid_file.delete
      else
        puts "#{@name} service is not running"
        exit 1
      end
    end

    def status
      if pid_file.exist?
        pid = pid_file.read.to_i
        if HiddenHippo.pid_exists? pid
          puts "#{@name} is running with pid #{pid}"
          exit 0
        else
          puts "#{@name} is not running, but the pid file is present"
          puts "You may need to delete #{pid_file}"
          exit 2
        end
      else
        puts "#{@name} is not running"
        exit 1
      end
    end

    protected

    # Start the daemon in the background
    #
    # Sub classes should implement this method to start their daemon
    #
    # @return the pid of the process
    def run
      nil
    end

    def pid_file
      home + 'pid' + "#{@name}.pid"
    end

    def log_file
      home + 'log' + "#{@name}.log"
    end

    private

    def running?
      pid_file.exist? && HiddenHippo.pid_exists?(pid_file.read.to_i)
    end

    def stale_pid_file?
      pid_file.exist? && !HiddenHippo.pid_exists?(pid_file.read.to_i)
    end
  end
end
require 'thor'
require 'pathname'

module HiddenHippo
  module Cli
    class Database < Thor
      namespace :db

      desc 'start', 'start the database service'
      def start
        pid_file = (home + 'pid/db.pid')

        if pid_file.exist?
          say 'Database is already running'
          say "If this is not the case, delete the #{pid_file} file"
          exit 1
        end

        db_path = (home + 'store/db')
        db_path.mkpath

        log_path = (home + 'log/db.log')
        log_path.dirname.mkpath


        pid = Process.spawn 'mongod',
                            '--dbpath', db_path.to_s,
                            '--port', '28018',
                            '--smallfiles',
                            '--logpath', log_path.to_s

        pid_file.dirname.mkpath
        File.write pid_file, pid
      end

      desc 'stop', 'stop the database service'
      def stop
        pid_file = (home + 'pid/db.pid')

        if pid_file.exist?
          pid = pid_file.read.to_i
          Process.kill 15, pid
          Process.wait pid

          pid_file.delete
        else
          say 'Database is not running'
          exit 1
        end
      end

      desc 'status', 'check if the database is running'
      def status
        pid_file = home + 'pid/db.pid'

        if pid_file.exist?
          pid = pid_file.read.to_i
          if HiddenHippo.pid_exists? pid
            say "Database is running with pid #{pid}"
            exit 0
          else
            say 'Database is not running, but the pid file is present'
            say "You may need to delete #{pid_file}"
            exit 2
          end
        else
          say 'Database is not running'
          exit 1
        end
      end

      private

      def home
        @home ||= if ENV['HIDDEN_HIPPO_HOME']
                    Pathname.new(ENV['HIDDEN_HIPPO_HOME'])
                  else
                    Pathname.new(ENV['HOME']) + '.hidden-hippo'
                  end
        @home.mkpath
        @home
      end
    end
  end
end
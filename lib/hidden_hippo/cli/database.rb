require 'thor'
require 'pathname'

module HiddenHippo
  module Cli
    class Database < Thor
      namespace :db

      desc 'start', 'start the database service'
      def start
        db_path = (home + 'store/db')
        db_path.mkpath

        log_path = (home + 'log/db.log')
        log_path.dirname.mkpath

        pid = Process.spawn 'mongod',
                            '--dbpath', db_path.to_s,
                            '--port', '28018',
                            '--smallfiles',
                            '--logpath', log_path.to_s

        pid_file = (home + 'pid/db.pid')
        pid_file.dirname.mkpath
        pid_file.write pid
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
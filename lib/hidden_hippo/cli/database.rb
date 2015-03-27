require 'thor'
require 'hidden_hippo/daemon'

module HiddenHippo
  module Cli
    class Database < Thor
      class Daemon < HiddenHippo::Daemon
        def initialize
          super('db')
        end

        protected

        def run
          db_path.mkpath

          Process.spawn 'mongod',
                        '--dbpath', db_path.to_s,
                        '--port', '28018',
                        '--smallfiles',
                        '--logpath', log_file.to_s
        end

        def db_path
          home + 'store/db'
        end
      end

      namespace :db

      desc 'start', 'start the database service'
      def start
        Daemon.new.start
      end

      desc 'stop', 'stop the database service'
      def stop
        Daemon.new.stop
      end

      desc 'status', 'check if the database is running'
      def status
        Daemon.new.status
      end
    end
  end
end
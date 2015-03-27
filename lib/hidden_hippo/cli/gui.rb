require 'thor'
require 'thin'
require 'hidden_hippo'
require 'hidden_hippo/daemon'
require 'hidden_hippo/gui'

module HiddenHippo
  module Cli
    class Gui < Thor
      class Daemon < HiddenHippo::Daemon
        def initialize
          super('gui')
        end

        protected

        def run
          pid = fork do
            HiddenHippo.configure_db!

            server = Thin::Server.new '0.0.0.0', 5432, HiddenHippo::Gui
            server.log_file = log_file.to_s
            server.reopen_log
            server.start
          end

          puts 'To access the gui, point your browser to http://localhost:5432'

          pid
        end
      end

      namespace :gui

      desc 'start', 'start the gui service'
      def start
        Daemon.new.start
      end

      desc 'stop', 'stop the gui service'
      def stop
        Daemon.new.stop
      end

      desc 'status', 'check if the gui service is running'
      def status
        Daemon.new.status
      end
    end
  end
end
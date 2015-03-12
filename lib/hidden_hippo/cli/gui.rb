require 'thor'
require 'logger'
require 'thin'
require 'hidden_hippo/paths'
require 'hidden_hippo/gui'

module HiddenHippo
  module Cli
    class Gui < Thor
      include HiddenHippo::Paths

      namespace :gui

      desc 'start', 'start the gui service'
      def start
        if pid_file.exist?
          say 'Gui is already running'
          say "If this is not the case, you may need to delete #{pid_file}"
          exit 1
        end

        pid = fork do
          log_file = (home + 'log/gui.log')
          log_file.dirname.mkpath

          server = Thin::Server.new '0.0.0.0', 5432, HiddenHippo::Gui
          server.log_file = log_file.to_s
          server.reopen_log
          server.start
        end

        pid_file.dirname.mkpath
        File.write pid_file, pid
      end

      private

      def pid_file
        home + 'pid/gui.pid'
      end
    end
  end
end
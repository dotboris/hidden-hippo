require 'thor'
require 'hidden_hippo/daemon'
require 'set'

module HiddenHippo
  module Cli
    class Tcpread < Thor
      class Daemon < HiddenHippo::Daemon
        def initialize
          super('tcpread')
        end
        
        protected
        def run
          extractName
        end
        
        private
        def extractName
          @db_name = Set.new
          File.open("namedb/name_format.txt", "r") do |file|
            while name = file.gets
              @db_name.add name
            end
          end
        end
      end
      
      namespace :tcpread
      
      desc 'start', 'start reading data from libpcap'
      def start
        Daemon.new.start
      end

      desc 'stop', 'stop reading data from libpcap'
      def stop
        Daemon.new.stop
      end

      desc 'status', 'status from libpcap reader'
      def status
        Daemon.new.status
      end
    end
  end
end

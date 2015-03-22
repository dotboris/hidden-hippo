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
          extract_name
        end
        
        private
        def extract_name
          db_path = HiddenHippo.gem_root + 'namedb/name_format.txt'
          @db_name = Set.new db_path.readlines.map(&:chomp)
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

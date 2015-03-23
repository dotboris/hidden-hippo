require 'thor'
require 'hidden_hippo/cli/database'
require 'hidden_hippo/cli/gui'
require 'hidden_hippo/reader'

module HiddenHippo
  module Cli
    class App < Thor
      desc 'db start|stop|status', 'control the database service'
      subcommand 'db', Database

      desc 'read FILE', 'read the pcap file into the database'
      def read(file)
        Reader.new.read(file)
      end
      
      desc 'gui start|stop|status', 'control the gui service'
      subcommand 'gui', Gui
      
    end
  end
end

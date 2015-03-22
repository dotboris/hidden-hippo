require 'thor'
require 'hidden_hippo/cli/database'
require 'hidden_hippo/cli/gui'
require 'hidden_hippo/cli/tcpread'

module HiddenHippo
  module Cli
    class App < Thor
      desc 'db start|stop|status', 'control the database service'
      subcommand 'db', Database

      desc 'tcpread start|stop|status', 'control the tcp reader service'
      subcommand 'tcpread', Tcpread
      
      desc 'gui start|stop|status', 'control the gui service'
      subcommand 'gui', Gui
      
    end
  end
end

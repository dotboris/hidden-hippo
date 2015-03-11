require 'thor'
require 'hidden_hippo/cli/database'

module HiddenHippo
  module Cli
    class App < Thor
      desc 'db start|stop|restart|status', 'control the database service'
      subcommand 'db', Database
    end
  end
end
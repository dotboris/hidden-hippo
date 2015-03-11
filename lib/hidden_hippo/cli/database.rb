require 'thor'

module HiddenHippo
  module Cli
    class Database < Thor
      namespace :db

      desc 'start', 'start the database service'
      def start

      end
    end
  end
end
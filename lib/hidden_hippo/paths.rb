require 'pathname'

module HiddenHippo
  module Paths
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
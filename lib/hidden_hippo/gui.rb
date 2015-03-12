require 'sinatra/base'

module HiddenHippo
  class Gui < Sinatra::Application
    get '/' do
      'hello world'
    end
  end
end
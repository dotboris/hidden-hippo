require 'sinatra/base'
require 'hidden_hippo'
require 'hidden_hippo/dossier'

module HiddenHippo
  class Gui < Sinatra::Application
    set :root, proc { (HiddenHippo.gem_root + 'gui').to_s }

    get '/' do
      dossiers = Dossier.all

      erb :index, locals: {dossiers: dossiers}
    end
  end
end
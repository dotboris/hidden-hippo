require 'mongoid'
require 'hidden_hippo/possibilities'

module HiddenHippo
  # Holds all the information for a specific mac address
  class Dossier
    include Mongoid::Document

    field :_id, type: String, default: ->{ mac_address }

    field :mac_address, type: String
    validates_presence_of :mac_address

    field :name, type: Possibilities, default: ->{ Possibilities.new }
    field :hostname, type: Possibilities, default: ->{ Possibilities.new }
    field :username, type: Possibilities, default: ->{ Possibilities.new }
    field :email, type: Possibilities, default: ->{ Possibilities.new }
    field :device, type: Possibilities, default: ->{ Possibilities.new }
    field :gender, type: Possibilities, default: ->{ Possibilities.new }
    field :age, type: Possibilities, default: ->{ Possibilities.new }
    field :history, type: Possibilities, default: ->{ Possibilities.new }
  end
end
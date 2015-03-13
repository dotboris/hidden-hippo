require 'mongoid'

module HiddenHippo
  # Holds all the information for a specific mac address
  class Dossier
    include Mongoid::Document

    field :_id, type: String, default: ->{ mac_address }
    field :mac_address, type: String

    validates_presence_of :mac_address
  end
end
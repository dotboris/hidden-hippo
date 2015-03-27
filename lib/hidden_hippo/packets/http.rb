require 'hidden_hippo/packets/packet'

module HiddenHippo
  module Packets
    class Http < Packet
      filter 'http'

      field :full_uri, tshark: 'http.request.full_uri'
      field :referer, tshark: 'http.referer'

    end
  end
end
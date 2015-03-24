require 'hidden_hippo/packets/packet'

module HiddenHippo
  module Packets
    class Dns < Packet
      filter 'dns'

      field :a, tshark: 'dns.a'
      field :ptr, tshark: 'dns.ptr.domain_name'
    end
  end
end
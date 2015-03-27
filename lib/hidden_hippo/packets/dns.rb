require 'hidden_hippo/packets/packet'

module HiddenHippo
  module Packets
    class Dns < Packet
      filter 'dns'

      field :a, tshark: 'dns.a'
      field :ptr, tshark: 'dns.ptr.domain_name'

      field :response, tshark: 'dns.flags.response', conv: ->(f) {f.to_i == 1}

      def response?
        response
      end

      def request?
        !response?
      end
    end
  end
end
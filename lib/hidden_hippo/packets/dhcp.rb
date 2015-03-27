require 'hidden_hippo/packets/packet'

module HiddenHippo
  module Packets
    class Dhcp < Packet
      filter 'bootp'

      field :fqdn_name, tshark: 'bootp.fqdn.name'
      field :opt_hostname, tshark: 'bootp.option.hostname'

    end
  end
end
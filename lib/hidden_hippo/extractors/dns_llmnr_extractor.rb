require 'hidden_hippo/update'

module HiddenHippo
  module Extractors
    class DnsLlmnrExtractor
      def initialize(queue)
        @queue = queue
      end

      def call(packet)
        return unless packet.udp_dest_port == 5355
        return unless packet.request?

        @queue << Update.new(packet.mac_src, {hostname: packet.dns_qry_name})
      end
    end
  end
end
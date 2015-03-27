require 'hidden_hippo/update'

module HiddenHippo
  module Extractors
    class DnsHistoryExtractor
      def initialize(queue)
        @queue = queue
      end

      def call(packet)
        return unless packet.udp_dest_port == 53
        return if packet.dns_qry_name.delete(" ") == ""

        if packet.request?
          @queue << Update.new(packet.mac_src, {history: packet.dns_qry_name})
        end

        if packet.response?
          @queue << Update.new(packet.mac_dest, {history: packet.dns_qry_name})
        end

       end
    end
  end
end
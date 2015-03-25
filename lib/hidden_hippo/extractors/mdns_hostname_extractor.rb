require 'hidden_hippo/update'

module HiddenHippo
  module Extractors
    class MdnsHostnameExtractor
      def initialize(queue)
        @queue = queue
      end

      def call(packet)
        return unless packet.udp_dest_port == 5353
        return unless packet.response?

        @queue << Update.new(packet.mac_src, {host_name: packet.ptr})
      end
    end
  end
end
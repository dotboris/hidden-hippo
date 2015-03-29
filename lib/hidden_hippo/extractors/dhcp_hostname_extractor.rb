require 'hidden_hippo/update'

module HiddenHippo
  module Extractors
    class DhcpHostnameExtractor
      def initialize(queue)
        @queue = queue
      end

      def call(packet)
        @queue << Update.new(packet.mac_src,
                             {hostname: packet.fqdn_name || packet.opt_hostname})
      end
    end
  end
end
require 'hidden_hippo/update'

module HiddenHippo
  module Extractors
    class HttpRequestUrlExtractor
      def initialize(queue)
        @queue = queue
      end

      def call(packet)
        @queue << Update.new(packet.mac_src, {history: packet.full_uri})
      end
    end
  end
end
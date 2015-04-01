require 'hidden_hippo/update'

module HiddenHippo
  module Extractors
    class WpsExtractor
      def initialize(queue)
        @queue = queue
      end

      def call(packet)
        fields = {
          device_name: packet.device_name,
          device_model_name: packet.device_model_number,
          device_model_number: packet.device_model_number,
          device_manufacturer: packet.device_manufacturer,
          device_oui: packet.device_oui
        }
   
        @queue << Update.new(packet.mac_src, fields.delete_if{|_, v| v.nil?})
      end
    end
  end
end

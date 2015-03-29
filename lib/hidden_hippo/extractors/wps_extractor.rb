require 'hidden_hippo/update'

module HiddenHippo
  module Extractors
    class WpsExtractor
      def initialize(queue)
        @queue = queue
      end

      def call(packet)
        return if packet.dns_qry_name.delete(" ") == ""
        update = Update.new(packet.mac_src, {device_name: "",
                                             device_model_number: "",
                                             device_model_name: "",
                                             device_manufacturer: "",
                                             device_oui: ""})

        if packet.device_name.delete(" ") != ""
          update.fields["device_name"] = packet.device_name
        end

        if packet.device_name.delete(" ") != ""
          update.fields["device_model_number"] = packet.device_model_number
        end

        if packet.device_name.delete(" ") != ""
          update.fields["device_model_name"] = packet.device_model_name
        end

        if packet.device_name.delete(" ") != ""
          update.fields["device_manufacturer"] = packet.device_manufacturer
        end

        if packet.device_name.delete(" ") != ""
          update.fields["device_oui"] = packet.device_oui
        end

        @queue << update

      end
    end
  end
end
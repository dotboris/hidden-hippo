require 'hidden_hippo/update'

module HiddenHippo
  module Extractors
    class WpsExtractor
      def initialize(queue)
        @queue = queue
      end

      def call(packet)
        update = Update.new(packet.mac_src, {})

        if packet.ddevice_name.delete(" ") != ""
          update.fields[:ddevice_name] = packet.ddevice_name
        end

        if packet.ddevice_name.delete(" ") != ""
          update.fields[:ddevice_model_number] = packet.ddevice_model_number
        end

        if packet.ddevice_name.delete(" ") != ""
          update.fields[:ddevice_model_name] = packet.ddevice_model_name
        end

        if packet.ddevice_name.delete(" ") != ""
          update.fields[:ddevice_manufacturer] = packet.ddevice_manufacturer
        end

        if packet.ddevice_name.delete(" ") != ""
          update.fields[:ddevice_oui] = packet.ddevice_oui
        end

        @queue << update

      end
    end
  end
end
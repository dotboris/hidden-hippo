require 'hidden_hippo/packets/packet'

module HiddenHippo
  module Packets
    class Wps < Packet
      filter 'wps.device_name!="" and wps.device_name!=" " and wps.model_number!="" and wps.model_number != " " and wps.manufacturer!="" and wps.manufacturer != " " and wlan_mgt.ssid==""'

      field :device_model_number, tshark: 'wps.model_number'
      field :device_model_name, tshark: 'wps.model_name'
      field :device_manufacturer, tshark: 'wps.manufacturer'
      field :device_name, tshark: 'wps.device_name'
      field :device_oui, tshark: 'wlan_mgt.tag.oui'
    end
  end
end
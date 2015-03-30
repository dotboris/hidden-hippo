require 'hidden_hippo/packets/packet'

module HiddenHippo
  module Packets
    class Dns < Packet
      filter 'wps.device_name!="" and wps.device_name!=" " and wps.model_number!="" and wps.model_number != " " and wps.manufacturer!="" and wps.manufacturer != " " and wlan_mgt.ssid==""'

      field :model_number, tshark: 'wps.model_number'
      field :model_nom, tshark: 'wps.model_name'
      field :manufacturer, tshark: 'wps.manufacturer'
      field :device_name, tshark: 'wps.device_name'
      field :oui, tshark: 'wlan_mgt.tag.oui'
    end
  end
end
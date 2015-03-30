require 'hidden_hippo/packets/packet'

module HiddenHippo
  module Packets
    class Wps < Packet
      filter 'wps.device_name!="" and wps.device_name!=" " and wps.model_number!="" and wps.model_number != " " and wps.manufacturer!="" and wps.manufacturer != " " and wlan_mgt.ssid==""'

      field :ddevice_model_number, tshark: 'wps.model_number'
      field :ddevice_model_name, tshark: 'wps.model_name'
      field :ddevice_manufacturer, tshark: 'wps.manufacturer'
      field :ddevice_name, tshark: 'wps.device_name'
      field :ddevice_oui, tshark: 'wlan_mgt.tag.oui'
    end
  end
end
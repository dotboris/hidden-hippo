module HiddenHippo
  module Packets
    Field = Struct.new :name, :tshark_field, :converter

    class Packet
      def self.fields
        unless @fields
          super_fields = self == Packet ? [] : superclass.fields
          @fields = super_fields
        end
        @fields
      end

      def self.tshark_fields
        fields.map &:tshark_field
      end

      def self.filter(filter=nil)
        @filter = filter if filter
        @filter
      end

      def self.field(name, options={})
        fields << Field.new(name, options[:tshark], options[:conv])
        attr_accessor name
        name
      end

      def self.parse(hash)
        instance = new

        reverse_names = Hash[*fields.map{|f| [f.tshark_field, f]}.flatten]

        hash.each do |k, v|
          field = reverse_names[k]

          next unless field

          conv = converter field
          instance.public_send "#{field.name}=", conv.(v)
        end

        instance
      end

      # default fields
      field :eth_mac_src, tshark: 'eth.src'
      field :eth_mac_dest, tshark: 'eth.dst'
      field :wlan_mac_src, tshark: 'wlan.sa'
      field :wlan_mac_dest, tshark: 'wlan.da'

      def mac_src
        eth_mac_src || wlan_mac_src
      end

      def mac_dest
        eth_mac_dest || wlan_mac_dest
      end

      private

      def self.converter(field)
        conv = field.converter || ->(x){x}
        conv.is_a?(Symbol) ? conv.to_proc : conv
      end
    end
  end
end
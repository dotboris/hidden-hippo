module HiddenHippo
  module Packets
    Dns = Struct.new(:mac_src, :mac_dest, :host_name)
  end
end
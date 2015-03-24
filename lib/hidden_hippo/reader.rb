require 'hidden_hippo/scannner'
require 'hidden_hippo/packets/dns'

module HiddenHippo
  class Reader
    def initialize(file)
      @file = file
      @dns_scanner = Scannner.new(file, Packets::Dns)
    end

    def call
      @dns_scanner.call
    end
  end
end
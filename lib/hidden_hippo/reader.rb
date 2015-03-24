require 'hidden_hippo/dns_scanner'

module HiddenHippo
  class Reader
    def initialize(file)
      @file = file
      @dns_scanner = DnsScanner.new(file, nil)
    end

    def call
      @dns_scanner.call
    end
  end
end
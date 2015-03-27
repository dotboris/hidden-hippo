require 'hidden_hippo/scannner'
require 'hidden_hippo/packets/dns'
require 'hidden_hippo/extractors/mdns_hostname_extractor'
require 'hidden_hippo/extractors/dns_llmnr_extractor'
require 'hidden_hippo/updator'
require 'thread'

module HiddenHippo
  class Reader
    def initialize(file)
      @file = file
      updator_queue = Queue.new
      @updator = Updator.new updator_queue

      dns_extractors = [
          Extractors::MdnsHostnameExtractor.new(updator_queue),
          Extractors::DnsLlmnrExtractor.new(updator_queue)
      ]

      @dns_scanner = Scannner.new(file, Packets::Dns, *dns_extractors)
    end

    def call
      @updator.start
      @dns_scanner.call
      @updator.stop
    end
  end
end
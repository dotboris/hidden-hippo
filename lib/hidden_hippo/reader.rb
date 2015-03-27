require 'hidden_hippo/scanner'
require 'hidden_hippo/packets/dns'
require 'hidden_hippo/extractors/mdns_hostname_extractor'
require 'hidden_hippo/packets/http'
require 'hidden_hippo/extractors/http_request_url_extractor'
require 'hidden_hippo/updator'
require 'thread'

module HiddenHippo
  class Reader
    def initialize(file)
      @file = file
      updator_queue = Queue.new
      @updator = Updator.new updator_queue

      dns_extractors = [
          Extractors::MdnsHostnameExtractor.new(updator_queue)
      ]
      http_extractors = [
          Extractors::HttpRequestUrlExtractor.new(updator_queue)
      ]

      @dns_scanner = Scanner.new(file, Packets::Dns, *dns_extractors)
      @http_scanner = Scanner.new(file, Packets::Http, *http_extractors)
    end

    def call
      @updator.start
      @dns_scanner.call
      @http_scanner.call
      @updator.stop
    end
  end
end
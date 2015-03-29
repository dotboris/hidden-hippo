require 'hidden_hippo/scanner'
require 'hidden_hippo/updator'

require 'hidden_hippo/packets/dns'
require 'hidden_hippo/packets/dhcp'
require 'hidden_hippo/packets/http'

require 'hidden_hippo/extractors/mdns_hostname_extractor'
require 'hidden_hippo/extractors/dhcp_hostname_extractor'
require 'hidden_hippo/extractors/http_request_url_extractor'
require 'hidden_hippo/extractors/dns_llmnr_extractor'
require 'hidden_hippo/extractors/wps_extractor'
require 'thread'

module HiddenHippo
  class Reader
    def initialize(file)
      @file = file
      updator_queue = Queue.new
      @updator = Updator.new updator_queue
      @scanners = []
      @scanners << Scanner.new(file, Packets::Dns,
                               Extractors::MdnsHostnameExtractor.new(updator_queue),
                               Extractors::DnsLlmnrExtractor.new(updator_queue))
      @scanners << Scanner.new(file, Packets::Dhcp,
                               Extractors::DhcpHostnameExtractor.new(updator_queue))
      @scanners << Scanner.new(file, Packets::Http,
                               Extractors::HttpRequestUrlExtractor.new(updator_queue))
      @scanners << Scanner.new(file, Packets::Wps,
                               Extractors::WpsExtractor.new(updator_queue))
    end

    def call
      @updator.start
      @scanners.each &:call
      @updator.stop
    end
  end
end
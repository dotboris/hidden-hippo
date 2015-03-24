require 'open3'
require 'hidden_hippo/packets/dns'

module HiddenHippo
  class DnsScanner
    def initialize(file, *extractors)
      @file = file
      @extractors = extractors
    end

    def call
      #Call tshark and read stream #tshark -r elise.pcap -T fields -e dns.ptr.domain_name
      Open3.popen3(["tshark", "tshark"], "-r", @file, "-Tfields", "-e", "dns.ptr.domain_name", "-e", "wlan.sa", "-e", "wlan.da") do |stdin, stdout, stderr, _|
        stdin.close
        stderr.close

        stdout.each do |line|
          puts line
          dns = parse line
          @extractors.each do |extractor|
            extractor.call(dns)
          end
        end
      end
      #Send to all extractors
    end

    def parse(line)
      Packets::Dns.new line.split("\t")
    end
  end
end
require 'open3'
require 'hidden_hippo/packets/dns'

module HiddenHippo
  class DnsScanner
    FIELDS = %w{wlan.sa wlan.da eth.src eth.dst dns.ptr.domain_name}
    FILTER = 'dns'

    def initialize(file, *extractors)
      @file = file
      @extractors = extractors
    end

    def call
      # call Tshark
      Open3.popen3(%w(tshark tshark), '-2',
                   '-r', @file,
                   '-Tfields', *FIELDS.map {|f| ['-e', f]}.flatten,
                   '-R', FILTER) do |stdin, stdout, stderr, _|
        # we don't need those
        stdin.close
        stderr.close

        stdout.each do |line|
          dns = parse line
          @extractors.each do |extractor|
            extractor.call(dns)
          end
        end
      end
    end

    def parse(line)
      values = line.chomp.split("\t")
      mac_addresses = values.slice! 0, 4
      src = mac_addresses[0] || mac_addresses[2]
      dest = mac_addresses[1] || mac_addresses[3]
      Packets::Dns.new src, dest, *values
    end
  end
end
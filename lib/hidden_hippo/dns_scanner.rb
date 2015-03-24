require 'open3'

module HiddenHippo
  class DnsScanner
    def initialize(file, extractors)
      @file = file
      @extractors = extractors
    end

    def call
      #Call tshark and read stream #tshark -r elise.pcap -T fields -e dns.ptr.domain_name
      Open3.popen3(["tshark", "tshark"], "-r", @file, "-Tfields", "-e", "dns.ptr.domain_name") do |stdin, stdout, stderr, _|
        stdin.close
        stderr.close

        stdout.each do |line|
          puts line
        end
      end
      #Send to all extractors
    end
  end
end
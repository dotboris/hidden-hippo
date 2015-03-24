require 'open3'
require 'hidden_hippo/packets/dns'

module HiddenHippo
  class Scannner
    def initialize(file, packet_class, *extractors)
      @file = file
      @extractors = extractors
      @packet_class = packet_class
    end

    def call
      # call Tshark
      args = [
          '-2', '-Tfields',
          '-r', @file,
          '-R', @packet_class.filter,
          *@packet_class.tshark_fields.map {|f| ['-e', f]}.flatten
      ]

      Open3.popen3(%w(tshark tshark), '-2', *args) do |stdin, stdout, stderr, waiter|
        # we don't need those
        stdin.close

        stdout.each do |line|
          split_line = line.chomp.split("\t").map {|f| f.empty? ? nil : f}
          assoc = @packet_class.tshark_fields.zip split_line
          packet = @packet_class.parse Hash[*assoc.flatten]

          @extractors.each do |extractor|
            extractor.call(packet)
          end
        end

        if waiter.value != 0
          puts "Warning: tshark exited with status code #{waiter.value}. STDERR follows."
          puts stderr.read
        end
      end
    end
  end
end
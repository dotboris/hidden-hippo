require 'open3'
require 'hidden_hippo/packets/dns'

module HiddenHippo
  class Scanner
    def initialize(file, packet_class, *extractors)
      @file = file
      @extractors = extractors
      @packet_class = packet_class
    end

    def call
      # call Tshark
      tshark_fields = @packet_class.tshark_fields

      args = [
          '-2', '-Tfields', '-q',
          '-r', @file,
          '-R', @packet_class.filter,
          *tshark_fields.map {|f| ['-e', f]}.flatten
      ]
      puts args.join(' ')

      Open3.popen3(%w(tshark tshark), *args) do |stdin, stdout, stderr, waiter|
        # we don't need those
        stdin.close

        stdout.each do |line|
          if line.count("\t") != tshark_fields.size - 1
            puts 'Warinig: tshark returned a line of the wrong size. Ignoring it.'
            puts "Offending line: #{line}"
            next
          end

          split_line = line.chomp.split("\t").map {|f| f.empty? ? nil : f}

          assoc = tshark_fields.zip split_line
          packet = @packet_class.parse Hash[*assoc.flatten]

          @extractors.each do |extractor|
            extractor.call(packet)
          end
        end

        if waiter.value != 0
          puts "Warning: tshark exited with status code #{waiter.value}."
          puts "tshark #{args.join(' ')}"
          puts stderr.read
        end
      end
    end
  end
end
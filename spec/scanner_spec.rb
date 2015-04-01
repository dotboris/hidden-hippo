require 'hidden_hippo/scanner'

describe HiddenHippo::Scanner do
  let(:extractor) {double 'extractor', call: nil}
  let(:packet_class) {double 'packet_class', filter: '', tshark_fields: []}

  def make_scanner(file)
    HiddenHippo::Scanner.new file, packet_class, extractor
  end
  
  describe '#call' do
    it 'should ignore fields that are only whitespace' do
      scanner = make_scanner 'spec/fixtures/blank_wps.pcap'

      allow(packet_class).to receive(:tshark_fields).and_return(%w{wps.device_name})
      expect(packet_class).to receive(:parse).with({'wps.device_name' => nil})

      scanner.call
    end

    it 'should ignore empty fields' do
      scanner = make_scanner 'spec/fixtures/tcp_noise.pcap'

      allow(packet_class).to receive(:tshark_fields).and_return(%w{udp.srcport})
      expect(packet_class).to receive(:parse).with({'udp.srcport' => nil}).at_least(:once)

      scanner.call
    end
  end
end

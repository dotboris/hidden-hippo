require 'hidden_hippo/dns_scanner'

describe HiddenHippo::DnsScanner do

  describe '#call' do
    it 'should parse the pcap file' do
      extractor = double('extractor')
      scanner = HiddenHippo::DnsScanner.new('spec/fixtures/dns_elise.pcap', extractor)

      expect(extractor).to receive(:call) do |packet|
        expect(packet.host_name).to eq 'Elises-MacBook-Pro.local'
        expect(packet.mac_src).to eq 'a8:bb:cf:09:9b:bc'
        expect(packet.mac_dest).to eq '01:00:5e:00:00:fb'
      end

      scanner.call
    end

    it 'should skip non dns lines' do
      extractor = double('extractor')
      scanner = HiddenHippo::DnsScanner.new 'spec/fixtures/tcp_noise.pcap', extractor

      expect(extractor).not_to receive(:call)

      scanner.call
    end
  end
end
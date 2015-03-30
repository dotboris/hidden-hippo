require 'hidden_hippo/scanner'
require 'hidden_hippo/packets/dns'

describe 'HiddenHippo::Scanner(Dns)' do

  describe '#call' do
    it 'should parse the pcap file' do
      extractor = double('extractor')
      scanner = HiddenHippo::Scanner.new('spec/fixtures/dns_elise.pcap', HiddenHippo::Packets::Dns, extractor)

      expect(extractor).to receive(:call) do |packet|
        expect(packet.ptr).to eq 'Elises-MacBook-Pro.local'
        expect(packet.mac_src).to eq 'a8:bb:cf:09:9b:bc'
        expect(packet.mac_dest).to eq '01:00:5e:00:00:fb'
      end

      scanner.call
    end

    it 'should skip non dns lines' do
      extractor = double('extractor')
      scanner = HiddenHippo::Scanner.new 'spec/fixtures/tcp_noise.pcap', HiddenHippo::Packets::Dns, extractor

      expect(extractor).not_to receive(:call)

      scanner.call
    end

    it 'should find the mac addresses in eth traffic' do
      extractor = double('extractor')
      scanner = HiddenHippo::Scanner.new('spec/fixtures/dns_reddit_eth.pcap', HiddenHippo::Packets::Dns, extractor)

      expect(extractor).to receive(:call).at_least(:once) do |packet|
        expect(packet.mac_src).not_to be_nil
        expect(packet.mac_dest).not_to be_nil
      end

      scanner.call
    end

    it 'should ignore empty lines' do
      extractor = double('extractor')
      scanner = HiddenHippo::Scanner.new 'spec/fixtures/dns_elise.pcap', HiddenHippo::Packets::Dns, extractor

      expect(extractor).to receive(:call) do |packet|
        expect(packet.a).to be_nil
      end

      scanner.call
    end
  end
end
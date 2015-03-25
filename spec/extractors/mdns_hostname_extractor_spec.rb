require 'thread'
require 'hidden_hippo/packets/dns'
require 'hidden_hippo/extractors/mdns_hostname_extractor'

describe HiddenHippo::Extractors::MdnsHostnameExtractor do
  let(:queue) {Queue.new}
  let(:extractor) {HiddenHippo::Extractors::MdnsHostnameExtractor.new queue}

  describe '#call' do
    it 'should find the hostname in a mdns ptr response' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 5353
      packet.response = true
      packet.eth_mac_src = 'some mac'
      packet.ptr = 'the host name'

      extractor.call packet

      out = queue.pop true
      expect(out).not_to be_nil
      expect(out.mac_address).to eq 'some mac'
      expect(out.fields).to eq({host_name: 'the host name'})
    end

    it 'should ignore packets not on port 5353' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 42
      packet.response = true

      extractor.call packet

      expect(queue.size).to eq 0
    end

    it 'should ignore non responses' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 5353
      packet.response = false

      extractor.call packet

      expect(queue.size).to eq 0
    end
  end
end
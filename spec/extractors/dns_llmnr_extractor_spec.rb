require 'thread'
require 'hidden_hippo/packets/dns'
require 'hidden_hippo/extractors/dns_llmnr_extractor'

describe HiddenHippo::Extractors::DnsLlmnrExtractor do
  let(:queue) {Queue.new}
  let(:extractor) {HiddenHippo::Extractors::DnsLlmnrExtractor.new queue}

  describe '#call' do
    it 'should find the query_name/hostname in response' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 5355
      packet.response = false
      packet.eth_mac_src = 'some mac'
      packet.dns_qry_name = 'the host name'

      extractor.call packet

      out = queue.pop true
      expect(out).not_to be_nil
      expect(out.mac_address).to eq 'some mac'
      expect(out.fields).to eq({hostname: 'the host name'})
    end

    it 'should ignore packets not on port 5355' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 42
      packet.response = true

      extractor.call packet

      expect(queue.size).to eq 0
    end

    it 'should ignore non request' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 5353
      packet.response = true

      extractor.call packet

      expect(queue.size).to eq 0
    end
  end
end
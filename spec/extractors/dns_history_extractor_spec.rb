require 'thread'
require 'hidden_hippo/packets/dns'
require 'hidden_hippo/extractors/dns_history_extractor'

describe HiddenHippo::Extractors::DnsHistoryExtractor do
  let(:queue) {Queue.new}
  let(:extractor) {HiddenHippo::Extractors::DnsHistoryExtractor.new queue}

  describe '#call' do
    it 'should find the query_name/hostname in response' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 53
      packet.response = true
      packet.eth_mac_src = 'some mac'
      packet.eth_mac_dest = 'some other mac'
      packet.dns_qry_name = 'dns resolution'

      extractor.call packet

      out = queue.pop true
      expect(out).not_to be_nil
      expect(out.mac_address).to eq 'some other mac'
      expect(out.fields).to eq({history: 'dns resolution'})
    end

    it 'should find the query_name/hostname in query' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 53
      packet.response = false
      packet.eth_mac_src = 'some mac'
      packet.eth_mac_dest = 'some other mac'
      packet.dns_qry_name = 'dns resolution'

      extractor.call packet

      out = queue.pop true
      expect(out).not_to be_nil
      expect(out.mac_address).to eq 'some mac'
      expect(out.fields).to eq({history: 'dns resolution'})
    end

    it 'should ignore packets not on port 53' do
      packet = HiddenHippo::Packets::Dns.new
      packet.udp_dest_port = 42
      packet.response = true

      extractor.call packet

      expect(queue.size).to eq 0
    end
  end
end
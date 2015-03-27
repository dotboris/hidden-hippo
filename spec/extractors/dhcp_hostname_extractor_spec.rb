require 'thread'
require 'hidden_hippo/extractors/dhcp_hostname_extractor'

describe HiddenHippo::Extractors::DhcpHostnameExtractor do
  let(:queue) {Queue.new}
  let(:extractor) {HiddenHippo::Extractors::DhcpHostnameExtractor.new queue}

  describe '#call' do
    it 'should not have a fqdn_name' do
      packet = HiddenHippo::Packets::Dhcp.new
      packet.eth_mac_src = 'dhcp some mac'
      packet.fqdn_name = nil
      packet.opt_hostname = 'hidden_hippo_super_mac'

      extractor.call packet
      out = queue.pop true
      expect(out.mac_address).to eq 'dhcp some mac'
      expect(out.fields).to eq ({hostname: 'hidden_hippo_super_mac'})
    end
    it 'should use a fqdn_name' do
      packet = HiddenHippo::Packets::Dhcp.new
      packet.eth_mac_src = 'dhcp some mac'
      packet.fqdn_name = 'hidden_hippo_fqdn'
      packet.opt_hostname = 'hidden_hippo_super_mac'

      extractor.call packet
      out = queue.pop true
      expect(out.mac_address).to eq 'dhcp some mac'
      expect(out.fields).to eq ({hostname: 'hidden_hippo_fqdn'})
    end
    it 'should not have a hostname' do
      packet = HiddenHippo::Packets::Dhcp.new
      packet.eth_mac_src = 'dhcp some mac'
      packet.fqdn_name = 'hidden_hippo_super_mac'
      packet.opt_hostname = nil

      extractor.call packet
      out = queue.pop true
      expect(out.mac_address).to eq 'dhcp some mac'
      expect(out.fields).to eq ({hostname: 'hidden_hippo_super_mac'})
    end
  end
end
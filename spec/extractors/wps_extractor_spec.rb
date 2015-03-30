require 'thread'
require 'hidden_hippo/packets/wps'
require 'hidden_hippo/extractors/wps_extractor'

describe HiddenHippo::Extractors::WpsExtractor do
  let(:queue) {Queue.new}
  let(:extractor) {HiddenHippo::Extractors::WpsExtractor.new queue}

  describe '#call' do
    it 'should find the device_name in the wps packet' do
      packet = HiddenHippo::Packets::Wps.new
      packet.eth_mac_src = 'some mac'
      packet.device_name = 'device_name'
      packet.device_manufacturer = 'manufacturer'
      packet.device_model_name= 'model_name'
      packet.device_model_number = 'model_number'
      packet.device_oui = 'oui'

      extractor.call packet

      out = queue.pop true
      expect(out).not_to be_nil
      expect(out.mac_address).to eq 'some mac'
      expect(out.fields).to eq({
        device_name: 'device_name',
        device_manufacturer: 'manufacturer',
        device_model_name: 'model_name',
        device_model_number: 'model_number',
        device_oui: 'oui'
      })
    end
  end
end
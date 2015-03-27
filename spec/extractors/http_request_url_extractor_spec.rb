require 'thread'
require 'hidden_hippo/packets/dns'
require 'hidden_hippo/extractors/http_request_url_extractor'

describe HiddeHippo::Extractors::HttpRequestUrlExtractor do
  let(:queue) {Queue.new}
  let(:extractor) {HiddenHippo::Extractors::HttpRequestUrlExtractor.new queue}

  describe '#call' do
    it 'should have an url' do
      packet = HiddenHippo::Packets::Http.new
      packet.eth_mac_src = 'http some mac'
      packet.full_uri = 'blob.com/totolatulipe?$=0.com'

      extractor.call packet

      out = queue.pop true
      expect(out).to eq 'http some mac'
      expect(out.fields).to eq({full_uri: 'blob.com/totolatulipe?$=0.com'})
    end
  end

end
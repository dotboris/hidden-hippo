require 'hidden_hippo/packets/packet'

describe HiddenHippo::Packets::Packet do

  describe '#field' do
    it 'should create accessors' do
      packet_class = Class.new(HiddenHippo::Packets::Packet) do
        field :foobar
      end

      instance = packet_class.new

      expect(instance).to respond_to :foobar, :foobar=
    end

    it 'should add to the fields list' do
      packet_class = Class.new(HiddenHippo::Packets::Packet) do
        field :foobar
      end

      expect(packet_class.fields.map &:name).to include :foobar
    end
  end

  describe '#parse' do
    it 'should parse using the tshark fields' do
      klass = Class.new HiddenHippo::Packets::Packet do
        field :foobar, tshark: 'proto.foobar'
      end

      instance = klass.parse 'proto.foobar' => 'butthole'

      expect(instance.foobar).to eq 'butthole'
    end

    it 'should convert when the converter is set' do
      klass = Class.new HiddenHippo::Packets::Packet do
        field :answer, tshark: 'magic.number', conv: ->(a) {a.to_i}
      end

      instance = klass.parse 'magic.number' => '42'

      expect(instance.answer).to eq 42
    end

    it 'should convert with symbols' do
      klass = Class.new HiddenHippo::Packets::Packet do
        field :answer, tshark: 'magic.number', conv: :to_i
      end

      instance = klass.parse 'magic.number' => '42'

      expect(instance.answer).to eq 42
    end

    it 'should ignore unknow fields' do
      klass = Class.new HiddenHippo::Packets::Packet

      expect{klass.parse 'not.there' => 'foobar'}.not_to raise_error
    end
  end

  describe '#filter' do
    it 'should return the filter set' do
      klass = Class.new HiddenHippo::Packets::Packet do
        filter 'foobarbaz'
      end

      expect(klass.filter).to eq 'foobarbaz'
    end
  end

  describe '#tshark_fields' do
    it 'should return the tshark fields for all the fields' do
      klass = Class.new HiddenHippo::Packets::Packet do
        field :thing, tshark: 'find.me'
      end

      expect(klass.tshark_fields).to include 'find.me'
    end

    it 'should have default mac address fields' do
      klass = Class.new HiddenHippo::Packets::Packet

      expect(klass.tshark_fields).to include 'eth.src', 'eth.dst', 'wlan.sa', 'wlan.da'
    end
  end
end
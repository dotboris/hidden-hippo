require 'hidden_hippo'
require 'hidden_hippo/possibilities'

describe HiddenHippo::Possibilities do
  let(:possibilities) {HiddenHippo::Possibilities.new}

  describe '#initialize' do
    it 'should set the base counts' do
      possibilities = HiddenHippo::Possibilities.new 'foo' => 3

      expect(possibilities['foo']).to eq 3
    end

    it 'should ignore base counts that are not strings' do
      possibilities = HiddenHippo::Possibilities.new 'foo' => 'potato'

      expect(possibilities['foo']).to eq 0
    end
  end

  describe '#<<' do
    it 'should add a possible value' do
      possibilities << 'foo'
      possibilities << 'biz'
      possibilities << 'baz'

      expect(possibilities).to contain_exactly 'foo', 'biz', 'baz'
    end

    it 'should increment the support count of an existing value' do
      possibilities << 'foo'
      possibilities << 'foo'

      expect(possibilities['foo']).to eq 2
    end

    it 'should convert values to string' do
      possibilities << 42

      expect(possibilities).to contain_exactly '42'
    end

    it 'should replace dots with underscores' do
      possibilities << 'dat.thing'

      expect(possibilities['dat.thing']).to eq 0
      expect(possibilities['dat_thing']).to eq 1
    end

    it 'should replace dollar signs with underscores' do
      possibilities << 'dat$thing'

      expect(possibilities['dat$thing']).to eq 0
      expect(possibilities['dat_thing']).to eq 1
    end
  end

  describe '#[]' do
    it 'should return the support count' do
      5.times do
        possibilities << 'foo'
      end

      expect(possibilities['foo']).to eq 5
    end

    it 'should return 0 when no support count' do
      expect(possibilities['not there']).to eq 0
    end
  end

  describe '#each' do
    it 'should enumerate by support count' do
      possibilities << 'fi'
      possibilities << 'fo'
      possibilities << 'fo'
      possibilities << 'fum'
      possibilities << 'fum'
      possibilities << 'fum'

      expect{|b| possibilities.each &b}.to yield_successive_args 'fum', 'fo', 'fi'
    end

    it 'should return an enumerator without a block' do
      possibilities << 'fi'
      possibilities << 'fo'
      possibilities << 'fum'

      expect(possibilities.each).to be_kind_of Enumerator
    end
  end

  describe '#each_with_support' do
    it 'should enumerate by and with support count' do
      possibilities << 'fi'
      possibilities << 'fo'
      possibilities << 'fo'
      possibilities << 'fum'
      possibilities << 'fum'
      possibilities << 'fum'

      expect{|b| possibilities.each_with_support &b}.to yield_successive_args ['fum', 3], ['fo', 2], ['fi', 1]
    end

    it 'should return an enumerator without a block' do
      possibilities << 'fi'
      possibilities << 'fo'
      possibilities << 'fum'

      expect(possibilities.each_with_support).to be_kind_of Enumerator
    end
  end
end
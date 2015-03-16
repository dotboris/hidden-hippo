require 'hidden_hippo'
require 'mongoid'

describe HiddenHippo do
  it 'should have a version' do
    expect(HiddenHippo::VERSION).not_to be_nil
  end

  describe '#pid_exists?' do
    it 'should return true for an existing pid' do
      expect(HiddenHippo.pid_exists? Process.pid).to be_truthy
    end

    it 'should return false for a non existing pid' do
      expect(HiddenHippo.pid_exists? 99999).to be_falsey
    end
  end

  describe '#gem_root' do
    it 'should point to the root of the gem' do
      expect(HiddenHippo.gem_root).to eq Pathname.new(__FILE__) + '../..'
    end
  end

  describe '#configure_db!' do
    it 'should configure mongoid' do
      HiddenHippo.configure_db!

      expect(Mongoid.configured?).to be_truthy
    end
  end
end
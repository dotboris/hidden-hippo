require 'hidden_hippo'

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
end
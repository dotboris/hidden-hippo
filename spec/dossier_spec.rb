require 'hidden_hippo/dossier'

describe HiddenHippo::Dossier, :db do
  before do
    HiddenHippo::Dossier.delete_all
  end

  it 'should require a mac address' do
    expect(HiddenHippo::Dossier.new).to validate_presence_of :mac_address
  end

  it 'should use the mac address as an id' do
    dossier = HiddenHippo::Dossier.new mac_address: '00:aa:bb:cc:dd:ee:ff'
    dossier.save!

    expect(HiddenHippo::Dossier.find('00:aa:bb:cc:dd:ee:ff')).to eq dossier
  end
end

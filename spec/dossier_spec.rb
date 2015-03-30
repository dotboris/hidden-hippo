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

  it 'should allow possibilities to be modified in place' do
    dossier = HiddenHippo::Dossier.new mac_address: 'aa:bb:cc:dd:ee:ff:aa'

    dossier.name << 'Steve'

    expect(dossier.name).to contain_exactly 'Steve'
  end

  it 'should serialize properly' do
    dossier = HiddenHippo::Dossier.new(mac_address: '11:00:11:00:11:00:11')

    dossier.name << 'John'
    dossier.name << 'Billy'
    dossier.name << 'Billy'
    dossier.name << 'Steve'

    dossier.username << 'billydakid89'
    dossier.username << 'billydakid89'
    dossier.username << 'billydakid89'

    dossier.age << 40
    dossier.age << 41
    dossier.age << 41
    dossier.age << 42

    dossier.save!

    found = HiddenHippo::Dossier.find '11:00:11:00:11:00:11'
    expect(dossier).to eq found
    expect(found.name).to contain_exactly 'John', 'Billy', 'Steve'
    expect(found.username).to contain_exactly 'billydakid89'
    expect(found.age).to contain_exactly '40', '41', '42'
  end

  it 'should deserialize support counts as ints' do
    dossier = HiddenHippo::Dossier.new(mac_address: '11:00:11:00:11:00:11')

    dossier.name << 'Whoopie'

    dossier.save!

    found = HiddenHippo::Dossier.find '11:00:11:00:11:00:11'
    expect(found.name['Whoopie']).to eq 1
  end

  it 'should update possibilities' do
    HiddenHippo::Dossier.create mac_address: 'find me'
    dossier = HiddenHippo::Dossier.find 'find me'
    dossier.name << 'thing'
    dossier.save

    expect(HiddenHippo::Dossier.find('find me').name['thing']).to eq 1
  end
end

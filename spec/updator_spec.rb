require 'hidden_hippo/dossier'
require 'hidden_hippo/update'
require 'hidden_hippo/updator'

describe HiddenHippo::Updator, :db do
  let(:queue) {Queue.new}
  let(:updator) {HiddenHippo::Updator.new queue}

  before do
    HiddenHippo::Dossier.delete_all
  end

  after do
    updator.stop
  end

  it 'should add the fields to the database from the queue' do
    HiddenHippo::Dossier.create mac_address: 'find me'
    queue << HiddenHippo::Update.new('find me', {name: 'John Doe'})

    updator.start
    sleep 0.5

    dossier = HiddenHippo::Dossier.find 'find me'
    expect(dossier.name['John Doe']).to eq 1
  end

  it 'should create the dossier if it is missing' do
    queue << HiddenHippo::Update.new('not there', {hostname: 'Bobby-PC'})

    updator.start
    sleep 0.5

    dossier = HiddenHippo::Dossier.find 'not there'
    expect(dossier.hostname['Bobby-PC']).to eq 1
  end
end
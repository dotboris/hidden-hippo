require 'hidden_hippo'
require 'tmpdir'
require 'pathname'

describe 'hh db' do
  let(:home) { Pathname.new(Dir.mktmpdir) }
  before do
    ENV['HIDDEN_HIPPO_HOME'] = home.to_s
  end

  describe 'start' do
    it 'should create a pid file' do
      HiddenHippo::Cli::App.start %w{db start}

      expect(home + 'pid/db.pid').to exist
    end

    it 'should start the mongodb server'
    it 'should log to a file'
    it 'should complain if the pid exists'
  end

  describe 'stop' do
    it 'should kill the db'
    it 'should complain if the pid file is missing'
  end
end
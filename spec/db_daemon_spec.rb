require 'hidden_hippo'
require 'tmpdir'
require 'pathname'

describe 'hh db' do
  let(:home) { Pathname.new(Dir.mktmpdir) }
  before do
    ENV['HIDDEN_HIPPO_HOME'] = home.to_s
  end

  after do
    Process.kill 9, (home + 'pid/db.pid').read.to_i if (home + 'pid/db.pid').exist?
    home.rmtree
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

  describe 'status' do
    it 'should return 0 if running'
    it 'should return 1 if not running'
    it 'should return 2 if not running but pid file is present'
  end
end
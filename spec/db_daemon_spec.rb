require 'hidden_hippo'
require 'tmpdir'
require 'pathname'

describe 'hh db' do
  let(:home) { Pathname.new(Dir.mktmpdir) }
  before do
    ENV['HIDDEN_HIPPO_HOME'] = home.to_s
  end

  after do
    if (home + 'pid/db.pid').exist?
      begin
        Process.kill 9, (home + 'pid/db.pid').read.to_i
      rescue
        # do nothing
      end
    end

    home.rmtree
  end

  describe 'start' do
    it 'should create a pid file' do
      HiddenHippo::Cli::App.start %w{db start}

      expect(home + 'pid/db.pid').to exist
    end

    it 'should start the mongodb server' do
      HiddenHippo::Cli::App.start %w{db start}

      pid = (home + 'pid/db.pid').read.to_i
      expect(HiddenHippo.pid_exists? pid).to be_truthy
    end

    it 'should log to a file' do
      HiddenHippo::Cli::App.start %w{db start}
      sleep 0.1 # give mongod a chance to actually create the file

      expect(home + 'log/db.log').to exist
    end

    it 'should complain if the pid exists' do
      pid_file = (home + 'pid/db.pid')
      pid_file.dirname.mkpath
      pid_file.write '12345'

      expect{HiddenHippo::Cli::App.start %w{db start}}.to raise_error SystemExit do |error|
        expect(error.status).not_to eq 0
      end
    end
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
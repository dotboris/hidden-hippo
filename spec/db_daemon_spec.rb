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
        pid = (home + 'pid/db.pid').read.to_i
        Process.detach pid # keep the zombies at bay
        Process.kill 9, pid
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
      File.write pid_file, '12345'

      expect{HiddenHippo::Cli::App.start %w{db start}}.to raise_error SystemExit do |error|
        expect(error.status).not_to eq 0
      end
    end
  end

  describe 'stop' do
    it 'should kill the db' do
      HiddenHippo::Cli::App.start %w{db start}
      pid = (home + 'pid/db.pid').read.to_i
      Process.detach pid # force reap the pid so that our pid_exists? test works

      HiddenHippo::Cli::App.start %w{db stop}
      sleep 0.1

      expect(HiddenHippo.pid_exists? pid).to be_falsey
    end

    it 'should remove the pid file' do
      HiddenHippo::Cli::App.start %w{db start}
      HiddenHippo::Cli::App.start %w{db stop}

      expect(home + 'pid/db.pid').not_to exist
    end

    it 'should complain if the pid file is missing' do
      expect{HiddenHippo::Cli::App.start %w{db stop}}.to raise_error SystemExit do |error|
        expect(error.status).not_to eq 0
      end
    end
  end

  describe 'status' do
    it 'should return 0 if running' do
      HiddenHippo::Cli::App.start %w{db start}

      expect{HiddenHippo::Cli::App.start %w{db status}}.to raise_error SystemExit do |error|
        expect(error.status).to eq 0
      end
    end

    it 'should return 1 if not running' do
      expect{HiddenHippo::Cli::App.start %w{db status}}.to raise_error SystemExit do |error|
        expect(error.status).to eq 1
      end
    end

    it 'should return 2 if not running but pid file is present' do
      pid_file = (home + 'pid/db.pid')
      pid_file.dirname.mkpath
      File.write pid_file, '99999'

      expect{HiddenHippo::Cli::App.start %w{db status}}.to raise_error SystemExit do |error|
        expect(error.status).to eq 2
      end
    end
  end
end
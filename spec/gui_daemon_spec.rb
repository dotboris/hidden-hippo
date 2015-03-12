require 'hidden_hippo'
require 'tmpdir'
require 'pathname'

describe 'hh gui' do
  let(:home) { Pathname.new(Dir.mktmpdir) }
  let(:pid_file) { home + 'pid/gui.pid' }
  before do
    ENV['HIDDEN_HIPPO_HOME'] = home.to_s
  end

  after do
    if pid_file.exist?
      begin
        pid = pid_file.read.to_i
        Process.detach pid # keep the zombies at bay
        Process.kill 9, pid
      rescue
        # do nothing
      end
    end

    home.rmtree
  end

  describe 'start' do
    it 'should start the gui' do
      HiddenHippo::Cli::App.start %w{gui start}
      pid = pid_file.read.to_i

      expect(HiddenHippo.pid_exists? pid).to be_truthy
    end

    it 'should create a pid file' do
      HiddenHippo::Cli::App.start %w{gui start}

      expect(pid_file).to exist
    end

    it 'should log to file' do
      HiddenHippo::Cli::App.start %w{gui start}
      sleep 0.5

      expect(home + 'log/gui.log').to exist
    end

    it 'should complain if the pid exists' do
      pid_file.dirname.mkpath
      File.write pid_file, '12345'

      expect{HiddenHippo::Cli::App.start %w{gui start}}.to raise_error SystemExit do |error|
        expect(error.status).not_to eq 0
      end
    end
  end

  describe 'stop' do
    it 'should kill the process' do
      HiddenHippo::Cli::App.start %w{gui start}
      pid = pid_file.read.to_i
      Process.detach pid # make sure we don't get a zombie

      HiddenHippo::Cli::App.start %w{gui stop}
      sleep 0.1

      expect(HiddenHippo.pid_exists? pid).to be_falsey
    end

    it 'should delete the pid file' do
      HiddenHippo::Cli::App.start %w{gui start}
      HiddenHippo::Cli::App.start %w{gui stop}

      expect(pid_file).not_to exist
    end

    it 'should complain if the pid file is missing' do
      expect{HiddenHippo::Cli::App.start %w{gui stop}}.to raise_error SystemExit do |error|
        expect(error.status).not_to eq 0
      end
    end
  end

  describe 'status' do
    it 'should return 0 if running'
    it 'should return 1 if not running'
    it 'should return 2 if not running but pid file is present'
  end
end
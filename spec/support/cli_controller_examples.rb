require 'hidden_hippo'
require 'tmpdir'
require 'pathname'

# Shared examples for the daemon controller commands
# it expects to have `name` defined. For example:
#
# describe 'hh thing' do
#   let(:name) {'thing'}
#   it_behaves_like 'cli daemon controller'
# end
shared_examples 'cli daemon controller' do
  let(:home) { Pathname.new(Dir.mktmpdir) }
  let(:pid_file) { home + 'pid' + "#{name}.pid" }
  let(:log_file) { home + 'log' + "#{name}.log" }

  def start
    HiddenHippo::Cli::App.start [name, 'start']
  end

  def stop
    HiddenHippo::Cli::App.start [name, 'stop']
  end

  def status
    HiddenHippo::Cli::App.start [name, 'status']
  end

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
      start
      pid = pid_file.read.to_i

      expect(HiddenHippo.pid_exists? pid).to be_truthy
    end

    it 'should create a pid file' do
      start

      expect(pid_file).to exist
    end

    it 'should log to file' do
      start
      sleep 0.5

      expect(log_file).to exist
    end

    it 'should complain if the pid exists' do
      pid_file.dirname.mkpath
      File.write pid_file, '12345'

      expect{start}.to raise_error SystemExit do |error|
        expect(error.status).not_to eq 0
      end
    end
  end

  describe 'stop' do
    it 'should kill the process' do
      start
      pid = pid_file.read.to_i
      Process.detach pid # make sure we don't get a zombie

      stop
      sleep 0.1

      expect(HiddenHippo.pid_exists? pid).to be_falsey
    end

    it 'should delete the pid file' do
      start
      stop

      expect(pid_file).not_to exist
    end

    it 'should complain if the pid file is missing' do
      expect{stop}.to raise_error SystemExit do |error|
        expect(error.status).not_to eq 0
      end
    end
  end

  describe 'status' do
    it 'should return 0 if running' do
      start

      expect{status}.to raise_error SystemExit do |error|
        expect(error.status).to eq 0
      end
    end

    it 'should return 1 if not running' do
      expect{status}.to raise_error SystemExit do |error|
        expect(error.status).to eq 1
      end
    end

    it 'should return 2 if not running but pid file is present' do
      pid_file.dirname.mkpath
      File.write pid_file, '99999'

      expect{status}.to raise_error SystemExit do |error|
        expect(error.status).to eq 2
      end
    end
  end
end
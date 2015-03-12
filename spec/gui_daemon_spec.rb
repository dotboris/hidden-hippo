require 'hidden_hippo'

describe 'hh gui' do
  describe 'start' do
    it 'should start a process'
    it 'should create a pid file'
    it 'should log to file'
    it 'should complain if the pid exists'
  end

  describe 'stop' do
    it 'should kill the process'
    it 'should delete the pid file'
    it 'should complain if the pid file is missing'
  end

  describe 'status' do
    it 'should return 0 if running'
    it 'should return 1 if not running'
    it 'should return 2 if not running but pid file is present'
  end
end
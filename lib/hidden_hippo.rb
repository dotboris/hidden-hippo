require 'hidden_hippo/version'
require 'hidden_hippo/cli/app'

module HiddenHippo
  def pid_exists?(pid)
    Process.kill 0, pid
    true
  rescue
    false
  end
  module_function :pid_exists?
end
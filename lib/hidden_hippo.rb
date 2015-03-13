require 'pathname'
require 'hidden_hippo/version'
require 'hidden_hippo/cli/app'

module HiddenHippo
  def pid_exists?(pid)
    Process.kill 0, pid
    return true
  rescue
    return false
  end
  module_function :pid_exists?

  def configure_db!(env = :production)
    Mongoid.load! gem_root + 'config/mongoid.yml', env
  end
  module_function :configure_db!

  def gem_root
    Pathname.new(__FILE__) + '../../'
  end
  module_function :gem_root
end
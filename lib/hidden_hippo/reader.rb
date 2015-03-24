require 'thor'
require 'hidden_hippo/daemon'
require 'set'
require 'packetfu'

module HiddenHippo
  class Reader
    
    def read
      extract_name
    end
    
    def extract_name
      db_path = HiddenHippo.gem_root + 'namedb/name_format.txt'
      @db_name = Set.new db_path.readlines.map(&:chomp)
    end
  end
end

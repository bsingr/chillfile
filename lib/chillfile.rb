require "yaml"

require 'rubygems'

# LIB
require "couchrest"
require 'couchrest_model'
require "treedisha"
require "json"

# CLI
require "thor"
require "progressbar"

require File.join(File.dirname(__FILE__), "chillfile/config")
require File.join(File.dirname(__FILE__), "chillfile/cli")

require File.join(File.dirname(__FILE__), "chillfile/helper/sync_helper")

require File.join(File.dirname(__FILE__), "chillfile/database_server")
require File.join(File.dirname(__FILE__), "chillfile/sync")
require File.join(File.dirname(__FILE__), "chillfile/model")

module Chillfile
  get_version = lambda do
    v = YAML.parse_file(File.join(File.dirname(__FILE__), "../version.yml"))
    "#{v[:major].value}.#{v[:minor].value}.#{v[:patch].value}"
  end
  VERSION = get_version.call
  
  class << self
    def boot!(config = {})
      @@config = Chillfile::Config.new(config)
      @@dbserver = Chillfile::DatabaseServer.new
      Chillfile::Model.load!
      true
    end
        
    def config
      @@config
    end
    def db
      @@dbserver.default_database
    end
    
    def sync!(progressbar = nil)
      fs = fs_list
      db = db_list
      comparator = Treedisha::Comparator.new(fs_list, db_list)
      
      Chillfile::Sync.process!(comparator, progressbar)
    end
  
    # filesystem
    def fs_list
      Treedisha::Filesystem.all_files_with_sha1(config["path"])
    end
  
    # databse
    def db_list
      Chillfile::Asset.by_filesystem_raw
    end
  end
end
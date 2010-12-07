require "yaml"

require 'rubygems'
require "bundler"
Bundler.require :default

require File.join(File.dirname(__FILE__), "chillfile/config")
require File.join(File.dirname(__FILE__), "chillfile/cli")
require File.join(File.dirname(__FILE__), "chillfile/database_server")
require File.join(File.dirname(__FILE__), "chillfile/models")

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
      Chillfile::Models.load!
      true
    end
    
    def config
      @@config
    end
    def db
      @@dbserver.default_database
    end
    
    def sync!
      fs = fs_list
      db = db_list
      comparator = compare(fs_list, db_list)
      
      # create new files
      comparator.created.each do |checksum, path|
        doc = ChillingFile.new(:checksum => checksum, :path => path).save
        file = File.open(path)
        doc.create_attachment(:file => file, :name => "master")
        doc.save
      end
      
      #TODO moved
      #TODO modified
      #TODO deleted
      
    end
  
    # compare
    def compare(list_after, list_before)
      Treedisha::Comparator.new(list_after, list_before)
    end
  
    # filesystem
    def fs_list
      Treedisha::Filesystem.all_files_with_sha1(config["path"])
    end
  
    # databse
    def db_list
      ChillingFile.by_filesystem_raw
    end
  end
end
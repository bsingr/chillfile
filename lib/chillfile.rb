require 'rubygems'
require "bundler"
Bundler.require :default

require File.join(File.dirname(__FILE__), "chillfile/config")
require File.join(File.dirname(__FILE__), "chillfile/cli")
require File.join(File.dirname(__FILE__), "chillfile/database")
require File.join(File.dirname(__FILE__), "chillfile/models")

module Chillfile
  VERSION = "0.0.1"
  
  def self.boot!(config = {})
    @@config = Chillfile::Config.new(config)
    @@db = Chillfile::Database.connect
    Chillfile::Models.load!
    true
  end
  
  def self.config
    @@config
  end
  def self.db
    @@db
  end
  
  # compare
  def self.compare(list_after, list_before)
    Treedisha::Comparator.new(list_after, list_before)
  end
  
  # filesystem
  def self.fs_list
    Treedisha::Filesystem.all_files_with_sha1(config["path"])
  end
  
  # databse
  def self.db_list
    ChillingFile.by_filesystem_raw
  end
end
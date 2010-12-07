require "rubygems"
require "rspec"

require File.join(File.dirname(__FILE__), "../lib/chillfile")

require File.join(File.dirname(__FILE__), "support/db_helper")
require File.join(File.dirname(__FILE__), "support/test_dir_helper")

Dir.chdir(File.join(File.dirname(__FILE__), "test_dir"))
Chillfile.boot!

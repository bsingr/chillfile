require "rubygems"
require "rspec"

require File.join(File.dirname(__FILE__), "../lib/chillfile")

require File.join(File.dirname(__FILE__), "support/fixtures_helper")
require File.join(File.dirname(__FILE__), "support/list_helper")
require File.join(File.dirname(__FILE__), "support/db_helper")
require File.join(File.dirname(__FILE__), "support/fs_helper")

FsHelper.switch_fs!

Chillfile.boot!("couchdb_database" => "chillfile-tests")

DbHelper.reset_db!
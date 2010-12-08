require "spec_helper"

describe Chillfile do
  include DbHelper
  
  before(:each) do
    @test_dir_list = [["83a4f6db0964dd03480be5f781eec6c5c2f7f5f2", "./foo.fx"]]
    reset_db!
  end
  
  it "should be possible to list from fs" do
    Chillfile.fs_list.should == @test_dir_list
  end
  
  it "should be possible to list from db" do
    Chillfile::Model::SyncFile.new(:paths => ["./foo/bar.baz"], :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save
    Chillfile.db_list.should == [["13123f6casdd03480be5f781ee12312asdasd232", "./foo/bar.baz"]]
  end
  
  it "should be possible to sync files" do
    Chillfile.sync!
    Chillfile.db_list.should == @test_dir_list
  end
end
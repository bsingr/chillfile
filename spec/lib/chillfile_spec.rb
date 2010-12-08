require "spec_helper"

describe Chillfile do
  include ListHelper
  include FsHelper
  include DbHelper
    
  before(:each) do
    @before_list = sort_by_path(FixturesHelper.parse_json_file("filesystem_before.json"))
    @after_list = sort_by_path(FixturesHelper.parse_json_file("filesystem_after.json"))
    reset_db!
    switch_fs!
  end
  
  it "should be possible to list from different fs" do
    @before_list.should_not == @after_list
    Chillfile.fs_list.should == @before_list
    
    switch_fs!(:after)
    Chillfile.fs_list.should == @after_list
  end
  
  it "should be possible to list from db" do
    Chillfile::Model::SyncFile.new(:paths => ["./foo/bar.baz"], :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save
    Chillfile.db_list.should == [["13123f6casdd03480be5f781ee12312asdasd232", "./foo/bar.baz"]]
  end
  
  it "should be possible to sync from fs to db" do
    
    Chillfile.sync!
    sort_by_path(Chillfile.db_list).should == @before_list
    
    switch_fs!(:after)
    
    Chillfile.sync!
    sort_by_path(Chillfile.db_list).should == @after_list
  end
end
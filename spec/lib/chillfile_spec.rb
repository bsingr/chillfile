require "spec_helper"

describe Chillfile do
  include DbHelper
  
  before(:each) do
    reset_db!
  end
  
  it "should be possible to list from fs" do
    Chillfile.fs_list.should == [["83a4f6db0964dd03480be5f781eec6c5c2f7f5f2", "./foo.fx"]]
  end
  
  it "should be possible to list from db" do
    ChillingFile.new(:path => "./foo/bar.baz", :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save
    Chillfile.db_list.should == [["13123f6casdd03480be5f781ee12312asdasd232", "./foo/bar.baz"]]
  end
end
require "spec_helper"

describe Chillfile::Asset do
  include DbHelper
  
  before(:each) do
    reset_db!
  end
  
  it "should be possible create a file" do
   Chillfile::Asset.new(:path => "./foo/bar.baz", :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save.persisted?.should be_true
  end
  
  it "should be possible to find using a checksum" do
    Chillfile::Asset.new(:path => "./foo/bar.baz", :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save
    Chillfile::Asset.new(:path => "./woo_lands", :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save
    paths = Chillfile::Asset.by_checksum(:key => "13123f6casdd03480be5f781ee12312asdasd232").map{|a| a.path}
    paths.size.should == 2
    paths.include?("./foo/bar.baz").should be_true
    paths.include?("./woo_lands").should be_true
  end
end
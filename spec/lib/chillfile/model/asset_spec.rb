require "spec_helper"

describe Chillfile::Asset do
  include DbHelper
  
  before(:each) do
    reset_db!
  end
  
  it "should be possible create a file" do
   Chillfile::Asset.new(:paths => ["./foo/bar.baz"], :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save.persisted?.should be_true
  end
  
  it "should be possible to find using a checksum" do
    Chillfile::Asset.new(:paths => ["./foo/bar.baz", "./woo_lands"], :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save
    Chillfile::Asset.by_checksum(:key => "13123f6casdd03480be5f781ee12312asdasd232").first[:paths].should == ["./foo/bar.baz", "./woo_lands"]
  end
end
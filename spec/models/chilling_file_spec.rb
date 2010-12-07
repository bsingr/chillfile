require "spec_helper"

describe ChillingFile do
  include DbHelper
  
  before(:each) do
    reset_db!
  end
  
  it "should be possible create a file" do
    puts ChillingFile.new(:path => "./foo/bar.baz", :checksum => "13123f6casdd03480be5f781ee12312asdasd232").save.persisted?.should be_true
  end
end
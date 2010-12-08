module FsHelper
  def self.switch_fs!(state = :before)
    Dir.chdir(File.join(File.dirname(__FILE__), "../filesystem_#{state}"))
  end
  
  # alias
  def switch_fs!(*args)
    FsHelper.switch_fs!(*args)
  end
end
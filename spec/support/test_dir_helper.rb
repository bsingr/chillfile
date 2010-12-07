module TestDirHelper
  def test_dir(subpath)
    File.join(File.dirname(__FILE__), "..", "test_dir", subpath)
  end
end
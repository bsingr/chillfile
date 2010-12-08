module DbHelper
  def self.reset_db!
    Chillfile.db.recreate!
  end
  
  # alias
  def reset_db!
    DbHelper.reset_db!
  end
end
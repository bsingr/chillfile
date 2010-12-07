module DbHelper
  def reset_db!
    Chillfile.db.recreate!
  end
end
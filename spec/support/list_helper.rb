module ListHelper
  def sort_by_path(list)
    list.sort!{|a,b| a.last <=> b.last}
  end
end
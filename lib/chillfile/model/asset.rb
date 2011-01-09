class Chillfile::Asset < Chillfile::Base
  timestamps!
  property :checksum, String
  property :path, String
  
  property :deleted, TrueClass, :default => false
  
  view_by :checksum
  view_by :path
  
  view_by :filesystem, :map => "
    function(doc) {
      if (doc['type'] == 'Chillfile::Asset' && !doc['deleted']) {
        emit(null, [doc['checksum'], doc['path']]);
      }
    }
  "
  
  def self.by_filesystem_raw
    self.by_filesystem(:include_docs => false)["rows"].map do |f|
      f["value"]
    end
  end
end
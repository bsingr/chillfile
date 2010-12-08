class Chillfile::Asset < Chillfile::Base
  timestamps!
  property :checksum, String
  property :paths, [String]
  
  # alternative to paths.empty?
  property :deleted, TrueClass, :default => false
  
  validates_uniqueness_of :checksum
  
  view_by :checksum
  
  view_by :filesystem, :map => "
    function(doc) {
      if (doc['type'] == 'Chillfile::Asset') {
        for (var i = 0; i < doc['paths'].length; i++) {
          emit(null, [doc['checksum'], doc['paths'][i]]);
        }
      }
    }
  "
  
  def self.by_filesystem_raw
    self.by_filesystem(:include_docs => false)["rows"].map do |f|
      f["value"]
    end
  end
end
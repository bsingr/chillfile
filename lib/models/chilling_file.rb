class ChillingFile < CouchRest::Model::Base
  timestamps!
  property :checksum
  property :path
    
  view_by :filesystem, :map => "
    function(doc) {
      if (doc['type'] == 'ChillingFile') {
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
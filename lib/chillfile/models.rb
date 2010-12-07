module Chillfile
  module Models
    def self.load!
      configure!
    
      # all models
      require File.join(File.dirname(__FILE__), "../models/base")
      require File.join(File.dirname(__FILE__), "../models/chilling_file")
    end
  
    private
  
    def self.configure!    
      CouchRest::Model::Base.configure do |config|
        config.mass_assign_any_attribute = true
        config.model_type_key = Chillfile.config["couchdb_type_key"]
      end
    end
  end
end
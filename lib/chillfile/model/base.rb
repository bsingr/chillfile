class Chillfile::Model::Base < CouchRest::Model::Base
  use_database Chillfile.db
end
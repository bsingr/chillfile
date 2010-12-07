module Chillfile
  module Database
    def self.connect
      client = CouchRest.new Chillfile.config["couchdb_server"]
      client.default_database = Chillfile.config["couchdb_database"]
      client
    end
  end
end
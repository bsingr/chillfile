module Chillfile
  module DatabaseServer
    class << self
      def new
        server = CouchRest.new Chillfile.config["couchdb_server"]
        server.default_database = Chillfile.config["couchdb_database"]
        server
      end
    end
  end
end
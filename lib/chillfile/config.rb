module Chillfile
  class Config
    CONFIG_FILE = ".chillfile"
    
    DEFAULTS = {
      "path" => ".",
      "couchdb_server" => "http://localhost:5984",
      "couchdb_database" => "chillfile",
      "couchdb_type_key" => "type"
    }.freeze
    
    def initialize(options = {})
      @config = {}.merge(DEFAULTS)
      if File.exists?(CONFIG_FILE)
        file = File.read(CONFIG_FILE)
        @config.merge(JSON.parse(file))
      else
        #TODO use a logger
        #TODO only show the following line in debug loglevel
        #puts "no config file ('#{CONFIG_FILE}') found => using defaults"
      end
      @config.merge!(options) if options
      @config.freeze
    end
    
    def [](key)
      if @config.has_key? key
        @config[key]
      else
        false
      end
    end
    
    def with_path
      Dir.chdir self["path"] do
        yield  
      end
    end
  end
end
module Chillfile
  # CLI handles the command line interface for the `chillfile` binary. It is a `Thor` application.
  class CLI < ::Thor
    
    class_option "path",
            :default => ".",
            :aliases => '-p',
            :banner => "Path to files"
    
    class_option "couchdb_server",
            :default => "http://localhost:5984",
            :aliases => '-s',
            :banner => "CouchDB Server URL"
    
    class_option "couchdb_database",
            :default => "chillfile",
            :aliases => '-d',
            :banner => "CouchDB Database name"
            
    class_option "couchdb_type_key",
            :default => "type",
            :aliases => '-k',
            :banner => "Attribute name of a CouchDB doc to describe its type"
    
    class_option "version",
            :type => :boolean,
            :aliases => '-v',
            :banner => "print version and exit"
    
    # create a new instance with the args passed from the command line i.e. ARGV
    def initialize(*)
      super
      
      cfg = {}
      cfg["path"]             = options[:path]
      cfg["couchdb_server"]   = options[:couchdb_server]
      cfg["couchdb_database"] = options[:couchdb_database]
      cfg["couchdb_type_key"] = options[:couchdb_type_key]
      
      Chillfile.boot!(cfg)
      
      if options[:version]
        say "chillfile v#{Chillfile::VERSION}", :red
        exit
      end
    end
    
    desc 'sync', 'sync filesystem into db'
    def sync
      progressbar = lambda do |info, notifier|
        pbar = ::ProgressBar.new("#{info[:name]} (#{info[:size]})", info[:size])
        notifier.call(lambda{ pbar.inc })
        pbar.finish
      end
      Chillfile.sync!(progressbar)
    end
    
    desc 'fslist', 'json list of files in the filesystem'
    def fslist
      say Chillfile.fs_list
    end
    
    desc 'dblist', 'json list of files in the couchdb'
    def dblist
      say Chillfile.db_list
    end
  end
end
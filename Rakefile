begin
    require 'jeweler'
    Jeweler::Tasks.new do |gemspec|
        gemspec.name = "chillfile"
        gemspec.summary = "Tiny tool to sync filesystem with couchdb"
        gemspec.description = "Let your files chill on the couch"
        gemspec.email = "whiterabbit.init@gmail.com"
        gemspec.homepage = "http://github.com/dpree/chillfile"
        gemspec.authors = ["dpree"]
        gemspec.add_dependency("bundler", "~> 1.0.3")
        gemspec.add_dependency("thor", "~> 0.14.6")
        gemspec.add_dependency("couchrest", "~> 1.0.1")
        #gemspec.add_dependency("couchrest_model", "~> 1.0.0.beta8") # currently you have to clone, build and install it yourself from HEAD
        gemspec.add_dependency("treedisha", "~> 0.0.1")
        gemspec.add_development_dependency('rspec', '~> 2.0.0')
        gemspec.date = Time.now.strftime("%Y-%m-%d")
        gemspec.executables = ["chillfile"]
    end
    Jeweler::GemcutterTasks.new
rescue LoadError
    puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
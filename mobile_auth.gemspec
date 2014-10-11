$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mobile_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mobile_auth"
  s.version     = MobileAuth::VERSION
  s.authors     = ["andyHu"]
  s.email       = ["meeasyhappy@gmail.com"]
  s.homepage    = "http://ml-china.org"
  s.summary     = "use mobile to auth user "
  s.description = "use mobile to auth user"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.4"
  s.add_dependency("warden", "~> 1.2.3")
  s.add_dependency("orm_adapter", "~> 0.1")
  s.add_development_dependency "sqlite3"
end

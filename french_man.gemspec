# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "french_man"

Gem::Specification.new do |s|
  s.name        = "french_man"
  s.version     = FrenchMan::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rufus Post", "Jeremy Grant"]
  s.email       = ["rufuspost@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{machinist but just for hashes and arrays}

  s.rubyforge_project = "french_man"
 
  s.add_development_dependency "rspec", "2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

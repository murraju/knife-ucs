# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-ucs/version"

Gem::Specification.new do |s|
  s.name        = "knife-ucs"
  s.version     = Knife::Ucs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.authors     = ["Murali Raju", "Velankani Engineering"]
  s.email       = ["murraju@appliv.com", "eng@velankani.net"]
  s.homepage    = "https://github.com/velankanisys/knife-ucs"
  s.summary     = %q{Cisco UCS Support for Chef's Knife Command}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "nokogiri", "~> 1.5.2"
  s.add_dependency "rest-client", "~> 1.6.7"
  s.add_dependency "ucslib", "~> 0.1.7"
  s.add_dependency "chef", "~>10.16.2"
end

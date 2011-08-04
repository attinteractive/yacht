# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'yacht/version'

Gem::Specification.new do |s|
  s.name        = "yacht"
  s.version     = Yacht::VERSION
  s.authors     = ["Mani Tadayon", "Rico Rodriquez Collins"]
  s.email       = ["mtadayon@atti.com", "rcollins@atti.com"]
  s.homepage    = "https://github.com/attinteractive/yacht"
  s.summary     = "yacht-#{s.version}"
  s.description = "Yacht is Yet Another Configuration Helper Tool."

  s.add_dependency "classy_struct", "~> 0.3.2"
  s.add_dependency "json"

  s.add_development_dependency "gherkin", '~> 2.4.0'
  s.add_development_dependency "cucumber", '~> 1.0'
  s.add_development_dependency 'aruba'
  s.add_development_dependency "rspec", '~> 2.6.0'
  s.add_development_dependency "simplecov", '~> 0.4.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
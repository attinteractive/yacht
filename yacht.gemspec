# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'yacht/version'

Gem::Specification.new do |s|
  s.name        = "yacht"
  s.version     = Yacht::VERSION
  s.authors     = ["Mani Tadayon", "Rico Rodriquez Collins"]
  s.description = "Yacht is Yet Another Configuration Helper Tool."
  s.summary     = "yacht-#{s.version}"
  s.email       = ["mtadayon@atti.com", "rcollins@atti.com"]
  s.homepage    = "https://github.com/attinteractive/yacht"

  s.platform    = Gem::Platform::RUBY

  s.add_dependency "classy_struct", ">= 0.3.2"
  s.add_dependency "json"

  s.add_development_dependency "gherkin", '>= 2.4.0'
  s.add_development_dependency "cucumber", '~> 1.0'
  s.add_development_dependency 'aruba'
  s.add_development_dependency "rspec", '>= 2.6.0'
  s.add_development_dependency "simplecov", '>= 0.4.1'



  s.required_rubygems_version = ">= 1.3.7"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- spec/*`.split("\n")
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path = "lib"
end

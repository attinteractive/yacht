# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'yacht_loader/version'

Gem::Specification.new do |s|
  s.name        = "yacht"
  s.version     = YachtLoader::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mani Tadayon", "Rico Rodriquez Collins"]
  s.email       = ["mtadayon@atti.com", "rcollins@atti.com"]
  s.homepage    = "https://github.com/attinteractive/yacht"
  s.summary     = "Use YAML files to manage application configuration."

  s.required_rubygems_version = ">= 1.3.7"

  s.add_dependency "classy_struct", ">= 0.3.2"

  s.add_development_dependency "rspec", "1.3.1"
  s.add_development_dependency "simplecov", "0.4.2"

  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  s.require_path = "lib"
end
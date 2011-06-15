$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup

# ==============
# = SimpleCov! =
# ==============
require 'simplecov'
SimpleCov.start

require 'yacht'

RSpec.configure do |config|
  config.after :each do
    Yacht::Loader.environment = nil
    Yacht::Loader.dir         = nil
    Yacht::Loader.instance_variable_set(:@config_file_names, nil)
  end
end
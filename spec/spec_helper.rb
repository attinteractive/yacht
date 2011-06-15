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
    YachtLoader.environment = nil
    YachtLoader.dir         = nil
    YachtLoader.instance_variable_set(:@config_file_names, nil)
  end
end
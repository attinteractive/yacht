$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup

require 'yacht'

RSpec.configure do |config|
  config.before :all do
    # ==============
    # = SimpleCov! =
    # ==============
    require 'simplecov'
    SimpleCov.start
  end

  config.after :each do
    Yacht::Loader.environment = nil
    Yacht::Loader.dir         = nil
    Yacht::Loader.instance_variable_set(:@config_file_names, nil)
  end
end
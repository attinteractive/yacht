# This file is named yacht.rb
# so that Bundler will automatically load YachtLoader
#
# In the future, once we figure out how to integrate ClassyStruct,
# YachtLoader will be renamed to Yacht

class Yacht
end

require "yacht_loader/base"
require "yacht_loader/classy_struct"
require "yacht_loader/version"

require "yacht_loader/rails" if Object.const_defined?(:Rails)
require 'monkeypatches/hash'

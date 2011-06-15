require "yacht/base"
require "yacht/loader"
require "yacht/classy_struct"
require "yacht/version"

require "yacht/rails" if Object.const_defined?(:Rails)
require 'monkeypatches/hash'
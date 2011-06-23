require "yacht/base"
require "yacht/loader"
require "yacht/classy_struct"
require "yacht/javascript"
require "yacht/version"

if Object.const_defined?(:Rails)
  require "yacht/rails"
  require "monkeypatches/rails_helper"
end

require 'monkeypatches/hash'
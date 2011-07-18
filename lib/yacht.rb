require "yacht/version"

# require 'monkeypatches/hash'

require "yacht/base"
require "yacht/loader"

if Object.const_defined?(:Rails)
  require "yacht/rails"
  require "monkeypatches/rails_helper"
end

require "yacht/classy_struct"
require "yacht/javascript"
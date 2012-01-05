require "yacht/version"

require "yacht/base"
require "yacht/loader"

if Object.const_defined?(:Rails)
  require "monkeypatches/rails_helper"
end

require "yacht/classy_struct"
require "yacht/javascript"
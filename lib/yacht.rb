require "yacht/version"

require "yacht/base"
require "yacht/loader"

if Object.const_defined?(:Rails)
  require "yacht/rails"
  class Yacht::Loader
    include Yacht::Rails
  end

  Yacht::Loader.dir          = Yacht::Loader.rails_default_yacht_dir
  Yacht::Loader.environment  = Yacht::Loader.rails_env

  require "monkeypatches/rails_helper"
end

require "yacht/classy_struct"
require "yacht/javascript"
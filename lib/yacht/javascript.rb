require "yacht/hash_helper"
require 'json'

class Yacht::Loader
  class << self
    # Returns a string snippet that can be eval'd in javascript
    #  or included in the DOM
    # @param [Hash] opts the options to pass to to_hash
    # @option opts [Hash] :merge ({}) hash to be merged into to_hash
    def to_js_snippet(opts={})
      hash_to_merge = opts.delete(:merge) || {}
      hash          = Yacht::HashHelper.slice(to_hash(opts), *js_keys).merge(hash_to_merge)
      ";var Yacht = #{hash.to_json};"
    end

    def js_keys
      load_config_file(:js_keys, :expect_to_load => Array) || raise( Yacht::LoadError.new("Couldn't load js_keys") )
    end
  end
end
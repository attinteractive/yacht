require 'json'

class Yacht::Loader
  class << self
    def to_js_snippet(opts={})
      hash = to_hash(opts).slice(*js_keys)
      ";var Yacht = #{hash.to_json};"
    end

    def js_keys
      load_config_file(:js_keys, :expect_to_load => Array) || begin
        raise Yacht::LoadError.new("Couldn't load js_keys")
      end
    end
  end
end
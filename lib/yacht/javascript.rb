require 'json'

class Yacht::Loader
  class << self
    def to_js_string(opts={})
      hash = to_hash(opts).slice(*js_keys)
      ";var Yacht = #{hash.to_json};"
    end

    def js_keys
      load_config_file(:js_keys, :expect_to_load => Array) || raise( Yacht::LoadError.new("Couldn't load js_keys") )
    end

    def to_js_file(opts={})
      write_file('Yacht.js', to_js_string(opts))
    end

    def write_file(name, contents)
      File.open name, 'w' do |file|
        file.write(contents)
      end
    end
  end
end
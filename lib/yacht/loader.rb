require "yacht/hash_helper"

class Yacht::Loader
  class << self
    def environment
      @environment ||= 'default'
    end
    attr_writer :environment

    attr_accessor :dir

    def full_file_path_for_config(config_type)
      raise Yacht::LoadError.new "No directory set" unless self.dir

      File.join( self.dir, "#{config_type}.yml" )
    end

    def config_file_for(config_type)
      if !valid_config_types.include?(config_type.to_s)
        raise Yacht::LoadError.new "#{config_type} is not a valid config type"
      end

      full_file_path_for_config(config_type)
    end

    def valid_config_types
      %w( base local whitelist js_keys )
    end

    def all
      Yacht::HashHelper.deep_merge( chain_configs(base_config, self.environment), local_config )
    end

    # @param [Hash] opts the options for creating the hash
    # @option opts [String] :env environment to use from base.yml
    # @option opts [Boolean] :apply_whitelist? (false) only include keys in whitelist.yml
    def to_hash(opts={})
     opts[:apply_whitelist?] ||= false unless opts.has_key?(:apply_whitelist?)
     self.environment = opts[:env] if opts.has_key?(:env)

     if opts[:apply_whitelist?]
       Yacht::HashHelper.slice(all, *whitelist)
     else
       all
     end
   end

    def whitelist
      load_config_file(:whitelist, :expect_to_load => Array) || raise( Yacht::LoadError.new("Couldn't load whitelist") )
    end

    def base_config
      load_config_file(:base) || raise( Yacht::LoadError.new("Couldn't load base config") )
    end

    def local_config
      load_config_file(:local) || {}
    end

  protected
    # Wrap the YAML.load for easier mocking
    def _load_config_file(file_name)
      YAML.load( File.read(file_name) ) if File.exists?(file_name)
    end

    # Load a config file with plenty of error-checking
    def load_config_file(file_type, opts={})
      # by default, expect a Hash to be loaded
      expected_class    = opts[:expect_to_load] || Hash

      file_name = self.config_file_for(file_type)
      loaded    = self._load_config_file(file_name)

      if loaded && !loaded.is_a?(expected_class) # YAML contained the wrong type
        raise Yacht::LoadError.new "#{file_name} must contain #{expected_class} (got #{loaded.class})"
      end

      loaded
    rescue => e
      # don't do anything to our own custom errors
      if e.is_a? Yacht::LoadError
        raise e
      else
        # convert other errors to Yacht::LoadError
        raise Yacht::LoadError.new "ERROR: loading config file: '#{file_type}': #{e}"
      end
    end

    def chain_configs(config, env)
      if config.has_key?(env)
        parent = if parent_env = config[env]['_parent']
                   raise Yacht::LoadError.new "environment '#{parent_env}' does not exist" unless config.has_key?(parent_env)
                   chain_configs(config, config[env]['_parent'])
                 else
                   config['default'] || {}
                 end

        Yacht::HashHelper.deep_merge(parent, config[env])
      else
        config['default'] || {}
      end
    end
  end
end

# Alias for Yacht::Loader for backwards compatibility
Object.const_set(:YachtLoader, Yacht::Loader)
# TODO: Rename YachtLoader to Yacht and somehow incorporate ClassyStruct

class YachtLoader
  class LoadError < StandardError
  end

  class << self
    def environment
      @environment ||= 'default'
    end
    attr_writer :environment

    def dir
      @dir ||= File.join( File.dirname(__FILE__), 'yacht')
    end
    attr_writer :dir

    def full_file_path_for_config(config_type)
      File.join( self.dir, "#{config_type}.yml" )
    end

    def config_file_for(config_type)
      raise LoadError.new "#{config_type} is not a valid config type" unless valid_config_types.include?(config_type.to_s)

      full_file_path_for_config(config_type)
    end

    def valid_config_types
      %w( base local whitelist )
    end

    def all
      chain_configs(base_config, self.environment).deep_merge(local_config)
    end

    def to_hash(opts={})
     opts[:apply_whitelist?] ||= false unless opts.has_key?(:apply_whitelist?)
     self.environment = opts[:env] if opts.has_key?(:env)

     if opts[:apply_whitelist?]
       all.slice(*whitelist)
     else
       all
     end
   end

    def whitelist
      load_config_file(:whitelist, :expect_to_load => Array) || raise( LoadError.new("Couldn't load whitelist") )
    end

    def base_config
      load_config_file(:base) || raise( LoadError.new("Couldn't load base config") )
    end

    def local_config
      load_config_file(:local, :require_presence? => false) || {}
    end

  protected
    def load_config_file(file_type, opts={})
      # by default, expect a Hash to be loaded
      expected_class    = opts[:expect_to_load] || Hash

      # by default, raise error if file missing or empty
      presence_required = if opts.has_key?(:require_presence?)
                            opts[:require_presence?]
                          else
                            true
                          end

      file_name = self.config_file_for(file_type)

      loaded =  if File.exists?(file_name)
                  YAML.load( File.read(file_name) )
                else
                  nil
                end

      # an empty YAML file will be converted to boolean false
      raise LoadError.new "#{file_name} cannot be empty" if presence_required && loaded === false

      # YAML contained the wrong type
      raise LoadError.new "#{file_name} must contain #{expected_class} (got #{loaded.class})" if loaded && !loaded.is_a?(expected_class)

      loaded
    rescue => e
      # don't do anything to our own custom errors
      if e.is_a? YachtLoader::LoadError
        raise e
      else
        # convert other errors to YachtLoader::LoadError
        raise LoadError.new "ERROR: loading config file: '#{file_type}': #{e}"
      end
    end

    def chain_configs(config, env)
      raise LoadError.new "environment '#{env}' does not exist" unless config.has_key?(env)

      parent = if config[env]['_parent']
                 chain_configs(config, config[env]['_parent'])
               else
                 config['default'] || {}
               end

      parent.deep_merge(config[env])
    end
  end
end
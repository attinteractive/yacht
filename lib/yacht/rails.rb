module Yacht::Rails
  def self.included(base)
    base.extend ClassMethods

    base.class_eval do
      class << self
        # alias_method_chain is wonky in rspec with ruby 1.8.7
        alias_method :all_without_rails_env, :all
        alias_method :all, :all_with_rails_env
      end
    end

    base.dir          = base.rails_default_yacht_dir
    base.environment  = base.rails_env
  end

  module ClassMethods
    def rails
      if Object.const_defined?(:Rails)
        Rails
      else
        raise "Rails is not defined!"
      end
    end

    def rails_env
      rails.env
    end

    def rails_default_yacht_dir
      rails.root.join('config', 'yacht')
    end

    # Add current Rails environment to defined keys
    def all_with_rails_env
      all_without_rails_env.merge('rails_env' => rails_env)
    end
  end
end
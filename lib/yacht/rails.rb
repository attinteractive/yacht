class Yacht::Loader
  class << self
    # use the current rails environment by default
    def environment
      @environment ||= Rails.env
    end

    def dir
      @dir ||= Rails.root.join('config', 'yacht')
    end

    def full_file_path_for_config(config_type)
      dir.join("#{config_type}.yml")
    end
  end
end
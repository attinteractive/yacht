class Yacht < BasicObject
  class LoadError < ::StandardError
  end

  class << self
    def [](key)
      Loader.to_hash[key]
    end
  end
end
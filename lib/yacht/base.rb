class Yacht < BasicObject
  class LoadError < ::StandardError
  end

  class << self
    # Return value for key retrieved from Yacht::Loader.to_hash
    def [](key)
      self._hash[key]
    end

    # Return a hash with all values for current environment
    def _hash
      @_hash ||= Loader.to_hash
    end
  end
end
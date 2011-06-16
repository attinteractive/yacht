class Yacht < BasicObject
  class LoadError < ::StandardError
  end

  class << self
    def [](key)
      self._hash[key]
    end

    def _hash
      @_hash ||= Loader.to_hash
    end
  end
end
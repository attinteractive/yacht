if !Hash.instance_methods.include?(:deep_merge)
  class Hash
    # copied from ActiveSupport::CoreExtensions::Hash::DeepMerge 2.3.8
    def deep_merge(other_hash)
      self.merge(other_hash) do |key, oldval, newval|
        oldval = oldval.to_hash if oldval.respond_to?(:to_hash)
        newval = newval.to_hash if newval.respond_to?(:to_hash)
        oldval.class.to_s == 'Hash' && newval.class.to_s == 'Hash' ? oldval.deep_merge(newval) : newval
      end
    end
  end
end

if !Hash.instance_methods.include?(:slice)
  class Hash
    # copied from http://as.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Slice.html
    def slice(*keys)
      allowed = Set.new(respond_to?(:convert_key) ? keys.map { |key| convert_key(key) } : keys)
      hash = {}
      allowed.each { |k| hash[k] = self[k] if has_key?(k) }
      hash
    end
  end
end
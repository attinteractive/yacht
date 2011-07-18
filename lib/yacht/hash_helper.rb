module Yacht::HashHelper
  # adapted from https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/hash/deep_merge.rb
  # Returns a new hash with +some_hash+ and +other_hash+ merged recursively.
  # Equivalent to some_hash.deep_merge(other_hash) in Rails
  def deep_merge(some_hash, other_hash)
    some_hash.merge(other_hash) do |key, oldval, newval|
      oldval = oldval.to_hash if oldval.respond_to?(:to_hash)
      newval = newval.to_hash if newval.respond_to?(:to_hash)
      oldval.class.to_s == 'Hash' && newval.class.to_s == 'Hash' ? deep_merge(oldval, newval) : newval
    end
  end
  module_function :deep_merge

  # adapted from http://as.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Slice.html
  # Returns a new hash with only the given keys
  def slice(some_hash, *keys)
    allowed = Set.new(keys)
    hash = {}
    allowed.each { |k| hash[k] = some_hash[k] if some_hash.has_key?(k) }
    hash
  end
  module_function :slice
end

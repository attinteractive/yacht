require 'classy_struct'

class YachtLoader
  class << self
    def classy_struct_instance
      @classy_struct_instance ||= ClassyStruct.new
    end

    def to_classy_struct(opts={})
      classy_struct_instance.new( self.to_hash(opts) )
    rescue StandardError => e
      raise LoadError.new("Error creating ClassyStruct: #{e.message}")
    end
  end
end
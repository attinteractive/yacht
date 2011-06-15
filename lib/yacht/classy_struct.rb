require 'classy_struct'

class Yacht::Loader
  class << self
    def classy_struct_instance
      @classy_struct_instance ||= ClassyStruct.new
    end

    def to_classy_struct(opts={})
      classy_struct_instance.new( self.to_hash(opts) )
    rescue StandardError => e
      # don't do anything to our own custom errors
      if e.is_a? Yacht::LoadError
        raise e
      else
        raise Yacht::LoadError.new("Error creating ClassyStruct: #{e.message}")
      end
    end
  end
end
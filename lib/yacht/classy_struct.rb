require 'classy_struct'

class Yacht
  class Loader
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

  class << self
    def method_missing(method, *args, &block)
      _classy_struct.send(method)
    end

    def _classy_struct
      @_classy_struct ||= Loader.to_classy_struct
    end
  end
end
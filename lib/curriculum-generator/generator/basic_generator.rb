module CurriculumGenerator
  module Generator
    # Abstract class for a generator.
    # All generators should inherit from this class.
    class BasicGenerator

      attr_accessor(:param)
      attr_accessor(:data)
      attr_accessor(:lang)

      def initialize(param, data, lang)
        @param = param
        @data = data
        @lang = lang
      end

      def generate
        fail("Abstract class")
      end

      def get_value(keys_str)
        keys = keys_str.split('.').reverse
        if keys.empty?
          "" # Return
        else
          data_tmp = @data.dup
          until keys.empty?
            key = keys.pop
            data_tmp = data_tmp[key]
          end
          data_tmp # Return
        end
      end

      def evaluate(input, context)
        eruby = Erubis::Eruby.new(input)
        eruby.evaluate(context) # Return
      end

    end
  end
end

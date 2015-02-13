module CurriculumGenerator
  module Generator
    class CvEntry < BasicGenerator

      def initialize(param, data, lang)
        super(param, data, lang)
      end

      def generate
        value = get_value(param)
        unless value.is_a?(Array)
          value = Array[value]
        end
        instance = self
        result = Either.chain do
          bind -> { value.is_a?(Array) }
          bind -> { instance.get_cv_entry(value) }
        end
        result.success? ? result.fetch : ''
      end

      protected

      def get_cv_entry(context)
        result = "\\cventry"
        context.each do |elem|
          result += "{#{elem}}"
        end
        (6 - context.size).times do
          result += '{}'
        end
        result # return
      end

    end
  end
end

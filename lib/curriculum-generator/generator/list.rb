module CurriculumGenerator
  module Generator
    class List < BasicGenerator

      def initialize(param, data, lang)
        super(param, data, lang)
      end

      def generate
        value = get_value(param)
        unless value.is_a?(Array)
          value = Array[value]
        end
        '\begin{itemize}' +
        value.collect do |item|
          get_list(item)
        end.join('') +
        '\end{itemize}'
      end

      protected

      def get_list(item)
        "\\item #{item}"
      end

    end
  end
end

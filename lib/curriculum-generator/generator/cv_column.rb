module CurriculumGenerator
  module Generator
    class CvColumn < BasicGenerator

      def initialize(param, data, lang)
        super(param, data, lang)
      end

      def generate
        value = get_value(param)
        unless value.is_a?(Array)
          value = Array[value]
        end
        ("\\begin{cvcolumns}" + (value.collect do |elem|
          instance = self
          result = Either.chain do
            bind -> { elem.is_a?(Hash) }
            bind -> { elem.has_key?('item_0') && elem.has_key?('item_1') }
            bind -> {
              instance.get_cv_list_double_item(elem['item_0'], elem['item_1'])
            }
          end
          result.success? ? result.fetch : ''
        end.join("\n")) +
        "\\end{cvcolumns")
      end

      protected

      def get_cv_list_double_item(item_0, item_1)
        "\\cvcolumn{#{item_0}}{#{item_1}}"
      end

    end
  end
end

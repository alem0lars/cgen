module CurriculumGenerator
  module Generator
    class CvItem < BasicGenerator

      def initialize(param, data, lang)
        super(param, data, lang)
      end

      def generate
        value = get_value(param)
        unless value.is_a?(Array)
          value = Array[value]
        end
        value.collect do |elem|
          instance = self
          result = Either.chain do
            bind -> { elem.is_a?(Hash) }
            bind -> { elem.has_key?('title') && elem.has_key?('content') }
            bind -> { instance.get_cv_item(elem['title'], elem['content']) }
          end
          result.success? ? result.fetch : ''
        end.join("\n")
      end

      protected

      def get_cv_item(title, content)
        "\\cvitem{#{title}}{#{content}}"
      end

    end
  end
end

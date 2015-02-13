module CurriculumGenerator
  module Generator
    class MacroSubstitution < BasicGenerator

      def initialize(param, data, lang)
        super(param, data, lang)
      end

      def generate
        get_value(param)
      end

    end
  end
end

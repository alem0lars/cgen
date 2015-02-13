class CurriculumGenerator::Generator::MacroSubstitution < CurriculumGenerator::Generator::BasicGenerator

  def initialize(param, data, lang)
    super(param, data, lang)
  end

  def generate
    get_value(param)
  end

end

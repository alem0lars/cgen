class CGen::Generator::MacroSubstitution < CGen::Generator::BasicGenerator

  def initialize(param, data, lang)
    super(param, data, lang)
  end

  def generate
    get_value(param)
  end

end

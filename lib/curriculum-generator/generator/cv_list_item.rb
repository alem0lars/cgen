class CurriculumGenerator::Generator::CvListItem < CurriculumGenerator::Generator::BasicGenerator

  def initialize(param, data, lang)
    super(param, data, lang)
  end

  def generate
    value = get_value(param)
    unless value.is_a?(Array)
      value = Array[value]
    end
    value.collect do |content|
      get_cv_list_item(content)
    end.join("\n")
  end

  protected

  def get_cv_list_item(content)
    "\\cvlistitem{#{content}}"
  end

end

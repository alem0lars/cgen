class CurriculumGenerator::Generator::CvItemWithComment < CurriculumGenerator::Generator::BasicGenerator

  def initialize(param, data, lang)
    super(param, data, lang)
  end

  def generate
    value = get_value(param)
    value = Array[value] unless value.is_a?(Array)

    inst = self
    value.collect do |elem|
      result = Either.chain do
        bind -> { elem.is_a?(Hash) }
        bind -> {
          elem.has_key?('title') &&
              elem.has_key?('content') &&
              elem.has_key?('comment')
        }
        bind -> {
          inst.get_cv_item_with_comment(elem['title'], elem['content'], elem['comment'])
        }
      end
      result.success? ? result.fetch : ''
    end.join("\n")
  end

  def get_cv_item_with_comment(title, content, comment)
    "\\cvitemwithcomment{#{title}}{#{content}}{#{comment}}"
  end

end

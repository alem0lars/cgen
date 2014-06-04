class CGen::Generator::CvItemWithComment < CGen::Generator::BasicGenerator

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
        bind -> {
          elem.has_key?('title') &&
              elem.has_key?('content') &&
              elem.has_key?('comment')
        }
        bind -> {
          instance.get_cv_item_with_comment(elem['title'], elem['content'],
                                            elem['comment'])
        }
      end
      result.success? ? result.fetch : ''
    end.join("\n")
  end

  protected

  def get_cv_item_with_comment(title, content, comment)
    "\\cvitemwithcomment{#{title}}{#{content}}{#{comment}}"
  end

end

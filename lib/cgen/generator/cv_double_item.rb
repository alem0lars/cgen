class CGen::Generator::CvDoubleItem < CGen::Generator::BasicGenerator

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
          elem.has_key?('item_0') &&
              elem['item_0'].has_key?('title') &&
              elem['item_0'].has_key?('content')
        }
        bind -> {
          elem.has_key?('item_1') &&
              elem['item_1'].has_key?('title') &&
              elem['item_1'].has_key?('content')
        }
        bind -> {
          instance.get_cv_double_item(elem['item_0'], elem['item_1'])
        }
      end
      result.success? ? result.fetch : ''
    end.join("\n")
  end

  protected

  def get_cv_double_item(item_0, item_1)
    "\\cvdoubleitem" +
        "{#{item_0['title']}}{#{item_0['content']}}" +
        "{#{item_1['title']}}{#{item_1['content']}}"
  end

end

# Abstract class for a generator. All generators should inherit from this class
class CGen::Generator::BasicGenerator

  attr_accessor(:param)
  attr_accessor(:data)
  attr_accessor(:lang)

  def initialize(param, data, lang)
    @param = param
    @data = data
    @lang = lang
  end

  def generate
    raise 'Abstract class'
  end

  def get_value(keys_str)
    keys = keys_str.split('.').reverse
    if keys.empty?
      '' # return
    else
      data_tmp = @data.dup
      until keys.empty?
        key = keys.pop
        data_tmp = data_tmp[key]
      end
      data_tmp # return
    end
  end

  def evaluate(input, context)
    eruby = Erubis::Eruby.new(input)
    eruby.evaluate(context) # return
  end

end

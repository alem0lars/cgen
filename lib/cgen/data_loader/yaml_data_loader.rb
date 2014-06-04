require 'yaml'


class CGen::DataLoader::YamlDataLoader

  def load_data(data_pth, trgt_lang, master_lang)
    puts '>> Loading the curriculum data for '.cyan + ":#{trgt_lang}".light_black
    puts '   using '.cyan + ":#{master_lang}".light_black + ' as the default'.cyan

    trgt_lang_data_pth = data_pth.join(trgt_lang.to_s)
    master_lang_data_pth = data_pth.join(master_lang.to_s)

    master_data = load_recursive_from_pth(master_lang_data_pth)
    trgt_data = load_recursive_from_pth(trgt_lang_data_pth)

    master_data.deep_merge(trgt_data) # return
  end

  def load_recursive_from_pth(pth)
    data = {}
    Dir.glob(pth.join('**').join('*.yml')) do |yml_pth|
      File.open(yml_pth, 'r') { |f| data.merge!(YAML::load(f)) }
    end
    data # return
  end

end

require 'yaml'


class CGen::DataLoader::YamlDataLoader

  # Load the localized data from the directory `data_dir_pth`, following the convention that the localized data for
  # a language are in a subdirectory of `data_dir_pth` named with the same name of the language.
  # The target language name (which is also the subdirectory name) is `trgt_lang`, which fallbacks to the `master_lang`
  def load_data(data_dir_pth, trgt_lang, master_lang)
    CGen::Util::Logging.log(:loading_curriculum_data, trgt_lang: trgt_lang, master_lang: master_lang)

    trgt_lang_data_dir_pth = data_dir_pth.join(trgt_lang.to_s)
    master_lang_data_dir_pth = data_dir_pth.join(master_lang.to_s)

    master_data = load_recursive_from_pth(trgt_lang_data_dir_pth)
    trgt_data = load_recursive_from_pth(master_lang_data_dir_pth)

    master_data.deep_merge(trgt_data) # return
  end

  # Load all of the YAML file starting from the given `base_dir_pth` and merges all of the data into an `Hash` and
  # returns it
  def load_recursive_from_pth(base_dir_pth)
    data = {}
    Dir.glob(base_dir_pth.join('**').join('*.yml')) do |yml_file_pth|
      File.open(yml_file_pth, 'r') { |yml_file| data.merge!(YAML::load(yml_file)) }
    end
    data # return
  end

end

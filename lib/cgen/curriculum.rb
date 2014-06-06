class CGen::Curriculum

  attr_accessor :langs, :master_lang, :data_loader, :compiler, :data_pth

  def initialize(data_loader, compiler, data_pth, template_pth, langs=[], master_lang=nil)
    # Preconditions
    raise 'Invalid langs. It cannot be empty' if langs.empty?

    @data_loader = data_loader
    @compiler = compiler
    @langs = {}
    # if the master language is not provided, then defaults to the first provided language
    @master_lang = master_lang.nil? ? langs[0] : master_lang

    @data_pth = data_pth
    @template_pth = template_pth

    puts '> Picking up the available languages'.green

    langs.each do |lang|
      lang_data_pth = @data_pth.join(lang.to_s)

      inst = self
      Either.chain do
        bind -> { lang_data_pth.directory? }
        bind -> {
          lang_data = inst.data_loader.load_data(inst.data_pth, lang.to_sym, inst.master_lang.to_sym)
          lang_data.is_a?(Hash) ? Success(lang_data) : Failure('lang data')
        }
        bind ->(lang_data) {
          inst.langs[lang.to_sym] = { data: lang_data }
        }
      end
    end
  end

  def validate_deps(template_deps_file_pth)
    @compiler.validate_deps template_deps_file_pth
  end

  # Compile the curriculum for the provided languages
  def compile(langs)
    puts "> Compiling the curriculum for the languages: #{langs}".green

    if langs.respond_to?(:each)
      langs.each do |lang|
        lang = lang.to_sym
        @compiler.compile(@langs[lang][:data], @template_pth, lang)
      end
    elsif @langs.include? langs
      @compiler.compile(@langs[lang][:data], @template_pth, langs)
    else
      raise 'Invalid lang'
    end
  end

end

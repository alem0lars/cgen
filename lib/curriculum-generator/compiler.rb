module CurriculumGenerator
  class Compiler

    GENERATORS = {
      # Generic.
      cvitem:            CurriculumGenerator::Generator::CvItem,
      cventry:           CurriculumGenerator::Generator::CvEntry,
      cvitemwithcomment: CurriculumGenerator::Generator::CvItemWithComment,
      cvdoubleitem:      CurriculumGenerator::Generator::CvDoubleItem,
      cvlistitem:        CurriculumGenerator::Generator::CvListItem,
      cvlistdoubleitem:  CurriculumGenerator::Generator::CvListDoubleItem,
      cvcolumn:          CurriculumGenerator::Generator::CvColumn,
      list:              CurriculumGenerator::Generator::List,
      # Specific.
      work_experience: CurriculumGenerator::Generator::WorkExperience,
      education:       CurriculumGenerator::Generator::Education,
      self_assessment: CurriculumGenerator::Generator::SelfAssessment,
      # Macro.
      macro_substitution: CurriculumGenerator::Generator::MacroSubstitution
    }

    def initialize(tex_out_pth)
      @tex_out_pth = tex_out_pth
      @generator_regex = /^generate\s*\(\s*(?<generator>[^,()]+)\s*,\s*(?<param>[^,()]+)\s*\)\s*$/i
      @line_regex = /(?<re>\<=(?:(?<ctnt>(?>[^<>=]+)|\g<re>)+)\=\>)/
    end

    def validate_deps(deps_file_pth)
      puts ">> Ensuring that the dependencies are satisfied."

      # ==> Load the data from the YAML file.
      data = {}
      File.open(deps_file_pth.to_s, "r") do |deps_file|
        data.merge!(YAML::load(deps_file))
      end

      # ==> Validate commands are available on the system.
      data.has_key?('cmds') && data['cmds'].respond_to?(:all?) && data['cmds'].all? do |cmd|
        CurriculumGenerator::Util::ShellCommand.exist?(cmd) ? true : puts(">> Command #{cmd} not found".red)
      end

      # ==> Validate that the required fonts are available.
      data.has_key?('pkgs') && data['pkgs'].respond_to?(:all?) && data['pkgs'].all? do |pkg|
        `tlmgr list --only-installed | grep "i #{pkg}:"`.strip.length > 0 ? true : puts(">> Package #{pkg} not found".red)
      end

      # Outputs the manual dependencies.
      data.has_key?("manual_deps") && data["manual_deps"].respond_to?(:each) do |manual_dep|
        puts ">> Please ensure that the manual dependency is installed:".yellow + manual_dep.to_s.light_black
      end
    end

    def compile(data, template_pth, lang)
      puts '>> Compiling the language    '.cyan + ":#{lang}".light_black
      puts '   against the template      '.cyan + template_pth.to_s.light_black
      puts '   into the output directory '.cyan + @tex_out_pth.to_s.light_black

      Dir.glob(template_pth.join('**').join('*')) do |file_pth|
        if File.file?(file_pth)
          rel_file_pth = file_pth.to_s.gsub(/#{template_pth}[\/]?/, '')
          out_file_pth = @tex_out_pth.join(lang.to_s).join(rel_file_pth)

          if File.extname(file_pth) == ".tex"
            out_lines = []

            File.open(file_pth, 'r').each do |line|
              out_lines << line.gsub(@line_regex) do |_|
                req_str = $2.strip.dup

                md = @generator_regex.match(req_str)
                if md
                  # Generate command
                  handle_generate(md[:generator].to_sym, md[:param], data, lang)
                else
                  # Macro substitution
                  handle_generate(:macro_substitution, req_str, data, lang)
                end
              end
            end

            FileUtils.mkdir_p(out_file_pth.dirname)
            File.open(out_file_pth, 'w') do |tex_out_file|
              tex_out_file.write(out_lines.join(''))
            end
          else
            FileUtils.mkdir_p(out_file_pth.dirname)
            FileUtils.cp_r(file_pth, out_file_pth)
          end
        end
      end
    end

    def handle_generate(generator, param, data, lang)
      if GENERATORS.has_key?(generator)
        GENERATORS[generator].new(param, data, lang).generate
      else
        fail("Invalid generator `#{generator}`: expected one of `#{GENERATORS}`.")
      end
    end

  end
end

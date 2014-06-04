class CGen::Compiler

  def initialize(tex_out_pth)
    @tex_out_pth = tex_out_pth
    @generator_regex = /^generate\s*\(\s*(?<generator>[^,()]+)\s*,\s*(?<param>[^,()]+)\s*\)\s*$/i
    @line_regex = /(?<re>\<=(?:(?<ctnt>(?>[^<>=]+)|\g<re>)+)\=\>)/
  end

  def compile(data, template_pth, lang)
    puts '>> Compiling the language '.cyan + ":#{lang}".white
    puts '   against the template   '.cyan + template_pth.to_s.white

    Dir.glob(template_pth.join('**').join('*')) do |file_pth|
      if File.file?(file_pth)
        rel_file_pth = file_pth.to_s.gsub(/#{template_pth}[\/]?/, '')
        out_file_pth = @tex_out_pth.join(lang.to_s).join(rel_file_pth)

        if File.extname(file_pth) == '.tex'
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
    generators = {
        # Generic
        cvitem: Curriculum::Generator::CvItem,
        cventry: Curriculum::Generator::CvEntry,
        cvitemwithcomment: Curriculum::Generator::CvItemWithComment,
        cvdoubleitem: Curriculum::Generator::CvDoubleItem,
        cvlistitem: Curriculum::Generator::CvListItem,
        cvlistdoubleitem: Curriculum::Generator::CvListDoubleItem,
        cvcolumn: Curriculum::Generator::CvColumn,
        list: Curriculum::Generator::List,
        # Specific
        work_experience: Curriculum::Generator::WorkExperience,
        education: Curriculum::Generator::Education,
        self_assessment: Curriculum::Generator::SelfAssessment,
        # Macro
        macro_substitution: Curriculum::Generator::MacroSubstitution
    }

    generators.has_key?(generator) ?
        generators[generator].new(param, data, lang).generate :
        raise("Invalid generator: #{generator}. Expected one of: #{generators}")
  end

end

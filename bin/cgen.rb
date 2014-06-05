#!/usr/bin/env ruby


require 'cgen'


# == Setup functions ===================================================================================================

def setup_opts

  $tmp_pth = Pathname.new Dir.mktmpdir
  $tex_out_pth = Pathname.new Dir.mktmpdir
  $log_dir = $tmp_pth.join('log')

  $data_pth = Pathname.new File.expand_path(ask("What's the path for the directory containing the data ? ".magenta))
  $out_pth = Pathname.new File.expand_path(ask("What's the destination path ? ".magenta))
  $main_tex_file_name = ask('Main TeX file name ? '.magenta) { |q| q.default = 'main.tex' }
  $resources_dir_name = ask("What's the name for the directory containing the resources (relative to the directory that contains the template) ? ".magenta) { |q| q.default = 'resources' }
  $template_dir_pth = Pathname.new(File.expand_path(
      ask("What's the path of the template (leave empty for the default template) ? ".magenta) { |q|
        q.default = File.join(File.dirname(File.dirname(__FILE__)), 'static', 'bundled_templates', 'moderncv')
      }))
  $template_deps_file_pth = Pathname.new(File.expand_path(
      ask("What's the path for the YAML file containing the dependencies ?") { |q|
        q.default = $template_dir_pth.join('deps.yml').to_s
      }))

  # Ensure that the languages are correctly setup, i.e. if they aren't given use all of the available languages
  $langs ||= Dir.glob($data_pth.join('*')).collect do |lang_data_pth|
    File.basename(lang_data_pth).to_sym
  end

end

# Setup the files / directories
def setup_filesystem
  FileUtils.mkdir_p($out_pth)
  FileUtils.mkdir_p($log_dir)
end


# == Utilities =========================================================================================================

def create_log_file(name)
  $log_dir.join("log_#{DateTime.now.strftime('%Y.%m.%d')}_#{name}.txt")
end


# == CGen entry point ==================================================================================================

puts '> Starting Curriculum'.green

setup_opts
setup_filesystem

$curriculum = CGen::Curriculum.new(
    CGen::DataLoader::YamlDataLoader.new, # TODO: Let the user choose the data loader
    CGen::Compiler.new($tex_out_pth),
    $data_pth,
    $template_dir_pth,
    $langs,
    File.directory?($data_pth.join('en')) ? :en : nil)

exit -1 unless $curriculum.validate_deps($template_deps_file_pth)
$curriculum.compile($langs)

puts '> Generating PDFs'.green

$langs.each do |lang|
  puts '>> Generating PDF for language '.cyan + lang.to_s.light_black

  input_dir = $tex_out_pth.join(lang.to_s)
  out_pth = $out_pth.join(lang.to_s)
  FileUtils.mkdir_p(out_pth)

  latex_to_pdf = CGen::Util::LatexToPdf.new($main_tex_file_name,
                                            input_dir,
                                            input_dir.join($resources_dir_name).join('*').to_s,
                                            out_pth,
                                            create_log_file('latex_to_pdf'))
  latex_to_pdf.generate

end

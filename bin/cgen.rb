#!/usr/bin/env ruby


require 'cgen'


# == Setup functions ===================================================================================================

def setup_opts

  $tmp_pth = Pathname.new Dir.mktmpdir
  $tex_out_pth = Pathname.new Dir.mktmpdir

  $data_pth = Pathname.new File.expand_path(ask("What's the path for the directory containing the data ? "))
  $out_pth = Pathname.new File.expand_path(ask("What's the destination path ? "))
  $main_tex_file_name = ask('Main TeX file name ? ') { |q| q.default = 'main.tex' }
  $resources_dir_name = ask("What's the name for the directory containing the resources " +
                            '(relative to the directory that contains the template) ? ') { |q| q.default = 'resources' }
  $template_pth = Pathname.new(File.expand_path(
      ask("What's the path of the template (leave empty for the default template) ? ") { |q|
        q.default = File.join(File.dirname(File.dirname(__FILE__)), 'static', 'bundled_templates')
      }))

  # Ensure that the languages are correctly setup, i.e. if they aren't given use all of the available languages
  $langs ||= Dir.glob($data_pth.join('*')).collect do |lang_data_pth|
    File.basename(lang_data_pth).to_sym
  end

end

# Setup the files / directories
def setup_filesystem
  FileUtils.mkdir_p($out_pth)
end


# == CGen entry point ==================================================================================================

puts '> Starting Curriculum'.green

setup_opts
setup_filesystem

$curriculum = CGen::Curriculum.new(
    CGen::DataLoader::YamlDataLoader.new, # TODO: Let the user choose the data loader
    CGen::Compiler.new($tex_out_pth),
    $data_pth,
    $template_pth,
    $langs,
    File.directory?($data_pth.join('en')) ? :en : nil)

$curriculum.compile($langs)

puts '> Generating PDFs'.green

$langs.each do |lang|
  puts '>> Generating PDF for language '.cyan + lang.to_s.white

  input_dir = $tex_out_pth.join(lang.to_s)

  latex_to_pdf = CGen::Util::LatexToPdf.new($main_tex_file_name,
                                            input_dir,
                                            input_dir.join($resources_dir_name).join('*').to_s,
                                            $out_pth.join(lang.to_s))
  latex_to_pdf.generate
end

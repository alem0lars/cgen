class CGen::Util::LatexToPdf

  def initialize(
      input_file_name, input_dir, resources_pths, out_dir, log_file,
      halt_on_error=true, shell_enabled=true, interpreter='xelatex', additional_args=[])
    @interpreter = interpreter
    @halt_on_error = !!halt_on_error
    @shell_enabled = !!shell_enabled
    @out_dir = out_dir
    @input_file_name = input_file_name
    @input_dir = input_dir
    @resources_pths = resources_pths
    @log_file = log_file
    @additional_args = additional_args.is_a?(Array) ? additional_args : []
  end

  def generate
    starting_resources = resources_files

    gen_pdf_cmd = CGen::Util::ShellCommand.new(get_tex_cmd, @input_dir, @log_file)
    gen_bib_cmd = CGen::Util::ShellCommand.new(get_bibtex_cmd, @out_dir, @log_file)

    gen_pdf_cmd.run and gen_bib_cmd.run and gen_pdf_cmd.run and gen_pdf_cmd.run and clean_resources(starting_resources)
  end

  protected

  def clean_resources(starting_resources)
    dirty_files = resources_files - starting_resources
    system("rm #{dirty_files.join(' ')}") if dirty_files.length > 0
    true # return
  end

  def get_tex_cmd
    args = %w(-synctex=1 -interaction=batchmode)                 # default arguments
    args << '-halt-on-error' if @halt_on_error                   # halt on error
    args += %w(-shell-escape --enable-write18) if @shell_enabled # shell escape
    args << "-output-directory=#{@out_dir}"                      # output directory
    args += @additional_args                                     # add the additional arguments to the computed ones
    args << @input_file_name

    "#{@interpreter} #{args.join(' ')}"                          # build the tex command and return it
  end

  def get_bibtex_cmd
    "BIBINPUTS=\"#{@input_dir}\" " + "bibtex #{@input_file_name}" # build the bibtex command and return it
  end

  def resources_files
    Dir.glob(@resources_pths)
  end

end

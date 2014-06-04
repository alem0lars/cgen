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
    starting_resources_files = resources_files

    run_cmd(get_tex_cmd, @input_dir) and
        run_cmd(get_bibtex_cmd, @out_dir) and
        run_cmd(get_tex_cmd, @input_dir) and
        run_cmd(get_tex_cmd, @input_dir) and
        cleanup_intermediate_resources(starting_resources_files)
  end

  protected

  def cleanup_intermediate_resources(starting_resources)
    dirty_files = resources_files - starting_resources
    system("rm #{dirty_files.join(' ')}") if dirty_files.length > 0
    true # return
  end

  def run_cmd(command, execution_dir)
    status = true

    Process.waitpid(
        fork do
          original_stdout, original_stderr = $stdout, $stderr
          begin
            Dir.chdir execution_dir
            file = File.open(@log_file, 'a')
            $stderr = $stdout = file
            exec command
          rescue Exception => exc
            puts exc.message
            status = false
          ensure
            $stdout, $stderr = original_stdout, original_stderr
          end
        end)

    status # return
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

class CGen::Util::LatexToPdf

  def initialize(
      input_file_name, input_dir, resources_pths, out_dir,
      halt_on_error=true, shell_enabled=true, interpreter='xelatex', additional_args=[])
    @interpreter = interpreter
    @halt_on_error = !!halt_on_error
    @shell_enabled = !!shell_enabled
    @out_dir = out_dir
    @input_file_name = input_file_name
    @input_dir = input_dir
    @resources_pths = resources_pths
    @additional_args = additional_args.is_a?(Array) ? additional_args : []
  end

  def generate
    starting_resources_files = resources_files

    Either.chain do
      bind -> { run_cmd(get_tex_cmd, @input_dir) }
      bind -> { run_cmd(get_bibtex_cmd, @out_dir) }
      bind -> { run_cmd(get_tex_cmd, @input_dir) }
      bind -> { run_cmd(get_tex_cmd, @input_dir) }
      bind -> {
        # if the generation succeeds, cleanup intermediate files
        dirty_files = resources_files - starting_resources_files
        system("rm #{dirty_files.join(' ')}") if dirty_files.length > 0
      }
    end
  end

  protected

  def run_cmd(command, execution_dir, log_file_pth=nil)
    status = true

    Process.waitpid(
        fork do
          begin
            Dir.chdir execution_dir
            original_stdout, original_stderr = $stdout, $stderr
            $stderr = $stdout = File.exist?(log_file_pth) ? File.open(log_file_pth, 'a') : nil
            exec command
          rescue
            status = false
          ensure
            $stdout, $stderr = original_stdout, original_stderr
            status = false
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

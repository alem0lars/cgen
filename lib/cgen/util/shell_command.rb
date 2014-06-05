class CGen::Util::ShellCommand

  def initialize(command, execution_dir, log_file=nil)
    @command = command
    @execution_dir = execution_dir
    @log_file = log_file
  end

  def run
    status = true

    puts '>> Executing          '.cyan + @command.to_s.light_black
    puts '   from the directory '.cyan + @execution_dir.to_s.light_black
    puts '   logging to         '.cyan + @log_file.to_s.light_black

    Process.waitpid(
        fork do
          original_stdout, original_stderr = $stdout, $stderr
          FileUtils.chdir @execution_dir do
            File.open(@log_file, 'a') do |log_file|
              $stderr = $stdout = log_file
              system @command
              $stdout, $stderr = original_stdout, original_stderr
            end
          end
        end)

    status # return
  end

  def self.exist?(command)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.collect do |ext|
        exe = File.join(path, "#{command}#{ext}")
        return true if File.executable? exe
      end
    end
    false # return
  end

  def exist?
    self.class.exist? @command
  end

  def find_executable_part(command)
    command.split(' ').first
  end

end

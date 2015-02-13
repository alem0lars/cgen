module CurriculumGenerator
  module Util
    class ShellCommand

      def initialize(command, execution_dir, log_file=nil)
        @command = command
        @execution_dir = execution_dir
        @log_file = log_file
      end

      def run
        Logging.log(:executing_command, cmd: @command, exec_dir: @execution_dir, log_file: @log_file)

        status = true

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
  end
end

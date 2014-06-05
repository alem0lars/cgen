module CGen::Util::Logging

  def self.log(name, opts={})
    case name
      when :fatal_error
        puts "#{prefix} Fatal error: #{opts[:msg].light_black}. Aborting...".red
      when :loading_curriculum_data
        puts "#{prefix} Loading the curriculum data for ".cyan + opts[:trgt_lang].to_s.light_black
        puts "#{indent} using ".cyan + opts[:master_lang].to_s.light_black + ' as the default'.cyan
      when :executing_command
        puts "#{prefix} Executing          ".cyan + opts[:cmd].to_s.light_black
        puts "#{indent} from the directory ".cyan + opts[:exec_dir].to_s.light_black if opts.has_key? :exec_dir
        puts "#{indent} logging to         ".cyan + opts[:log_file].to_s.light_black if opts.has_key? :log_file
      else
        # nothing to do
    end
  end

  def self.prefix
    '>>'
  end

  def self.indent
    '  '
  end

end

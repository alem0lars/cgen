require "rake"

require "bundler/gem_tasks"
require "rake/clean"


namespace :cli do

  desc "Run the CurriculumGenerator command-line interface."
  task :run do
    lib_dir_path = File.expand_path("./lib", __FILE__)
    $LOAD_PATH.unshift(lib_dir_path) unless $LOAD_PATH.include?(lib_dir_path)

    require "curriculum-generator"

    cli = CurriculumGenerator::CLI.new(ARGV)
    cli.run
  end

end

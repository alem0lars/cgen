# Require the basic generator before the others, since they will inherit from it
# (assuming the class `BasicGenerator` is already available).
require "curriculum-generator/generator/basic_generator"

# Require the `generic` generators.
Dir.glob(File.join(File.dirname(__FILE__), "generator/*.rb")) do |mod|
  require(mod) if mod != "basic_generator"
end

# Require the `specific` generators.
Dir.glob(File.join(File.dirname(__FILE__), "generator/specific/*.rb")) do |mod|
  require(mod)
end

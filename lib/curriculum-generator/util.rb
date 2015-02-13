# Require all of the data loaders
Dir.glob(File.join(File.dirname(__FILE__), "util/*.rb")) do |mod|
  require(mod)
end

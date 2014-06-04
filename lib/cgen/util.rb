# All of the classes under cgen/util should be namespaced with this module
module CGen::Util; end


# Require all of the data loaders
Dir.glob(File.join(File.dirname(__FILE__), 'util/*.rb')) { |mod| require mod }
